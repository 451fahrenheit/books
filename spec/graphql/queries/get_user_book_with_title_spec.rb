require 'rails_helper'

module Queries

  RSpec.describe 'GetUserBookWithTitle', type: :request do

    it "fetches the book based on given title" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      Book.create!(volumeId:"goodbook0",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user,
        is_public: true
      )
      Book.create!(volumeId:"goodbook0",
        title:"total",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: get_user_book_with_title, variables: {title: "title"} }
      
      jsonResponse = JSON.parse(response.body)
      expect((jsonResponse["data"]["getUserBookWithTitle"]).count).to eq(1)


    end
    it "returns unauthotized when the user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      Book.create!(volumeId:"goodbook0",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user,
        is_public: true

      )
      Book.create!(volumeId:"goodbook0",
        title:"total",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user,
        is_public: true
      )
      post '/graphql', params: { query: get_user_book_with_title, variables: {title: "title"} }
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse["errors"].first["message"]).to eq('Unauthorized')


    end
    it "returns zero found when the book is not available" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      Book.create!(volumeId:"goodbook0",
        title:"tesla",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user,
        is_public: true
      )
      Book.create!(volumeId:"goodbook0",
        title:"total",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user,
        is_public: true
      )

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: get_user_book_with_title, variables: {title: "title"} }
      jsonResponse = JSON.parse(response.body)
      expect((jsonResponse["data"]["getUserBookWithTitle"]).count).to eq(0)
    end

    def signin_query
      <<-GRAPHQL
			mutation LoginUser($email: String!, $password: String!) {
				loginUser(input:{credentials:{email:$email, password:$password}}){
					token
					}
			
			}			
      GRAPHQL
    end

    def get_user_book_with_title
      <<-GRAPHQL
      query GetUserBookWithTitle {
        getUserBookWithTitle(title:"title"){
          volumeId
          title
          subtitle
          description
          authors
          language
          pubDate
          smallthumbnail
          thumbnail
          isPublic
        }
        }
      GRAPHQL
    end

  end
end