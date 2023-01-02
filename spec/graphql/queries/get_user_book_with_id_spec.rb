require 'rails_helper'

module Queries

  RSpec.describe 'GetUserBookWithId', type: :request do

    it "fetches the book based on given id" do
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

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: get_user_book_with_id, variables: {id: 1} }
      
      jsonResponse = JSON.parse(response.body)

      expect((jsonResponse["data"]["getUserBookWithId"]["id"])).to eq("1")


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
      post '/graphql', params: { query: get_user_book_with_id, variables: {id: 1} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq('Unauthorized')


    end
    it "returns 0 books when the book is not available" do
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
      post '/graphql', params: { query: get_user_book_with_id, variables: {id: 3} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq('No Book Found')

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

    def get_user_book_with_id
      <<-GRAPHQL
      query GetUserBookWithId($id: ID!) {
        getUserBookWithId(id:$id){
          id
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