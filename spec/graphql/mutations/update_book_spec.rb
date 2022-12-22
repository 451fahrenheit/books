require 'rails_helper'

module Mutations
  RSpec.describe "UpdateBook", type: :request do

    it "makes the existing book public" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      Book.create!(volumeId:"goodbook",
        title:"title",
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
      post '/graphql', params: {query: update_book, variables:{ id:1,
        isPublic:true,        
      }}
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse.dig("data", "updateBook","book","isPublic")).to eq(true)
    end
    it "throws error when unauthorized user tries to make it public" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "cultsharing@gmail.com", password: "12345678")
      Book.create!(volumeId:"goodbook",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@gmail.com",password: "12345678"} }
      post '/graphql', params: {query: update_book, variables:{ id:1,
        isPublic:true,        
      }}
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      Book.create!(volumeId:"goodbook",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user
      )

      post '/graphql', params: { query: update_book }
      jsonResponse = JSON.parse(response.body)
   
      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    def update_book
      <<~GRAPHQL
      mutation UpdateBook {
        updateBook(input: {isPublic: true, id: 1}) {
          book {
            id
            volumeId
            title
            userId
            isPublic
          }
        }
      }
      GRAPHQL
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
  end
end