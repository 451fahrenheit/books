require 'rails_helper'

module Queries
  RSpec.describe 'FetchUserBooks', type: :request do

    it "fetches all the books from user's library" do
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
      Book.create!(volumeId:"goodbook1",
        title:"title1",
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
      post '/graphql', params: { query: fetch_any_user_books, variables: {id: user.id} }
      jsonResponse = JSON.parse(response.body)
      expect((jsonResponse["data"]["fetchAnyUserBooks"]).count).to eq(2)
    end
    
    it "returns User library is empty when no books are found" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: fetch_any_user_books, variables: {id: 2} }
      jsonResponse = JSON.parse(response.body)
   
      expect((jsonResponse["data"]["fetchAnyUserBooks"]).count).to eq(0)
    end

    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")


      post '/graphql', params: { query: fetch_any_user_books, variables: {id: 2} }
      jsonResponse = JSON.parse(response.body)
   
      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
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

    def fetch_any_user_books
      <<-GRAPHQL
      query FetchAnyUserBooks($id: ID!) {
        fetchAnyUserBooks(id:$id){
          volumeId
          title
          subtitle
          description
          authors
          language
          pubDate
          smallthumbnail
          thumbnail
        }
        }
      GRAPHQL
    end


  end

end