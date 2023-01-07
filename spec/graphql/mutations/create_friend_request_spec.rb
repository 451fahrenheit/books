require "rails_helper"
module Mutations
  RSpec.describe 'CreateFriendRequest', type: :request do
    
    it "Creates a new friend request" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentToId: user1.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["data"]["addFriend"]["success"]).to eq(true)
    end
    it "Throws an error when the user does not exist" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      jsonResponse = JSON.parse(response.body)
      post '/graphql', params: {query: query, variables:{
        sentToId: 21
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Requested user does not exist")
    end
    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")

      post '/graphql', params: {query: query, variables:{
        sentToId: user.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    
    def query
      <<~GRAPHQL
      mutation AddFriend($sentToId: ID!){
        addFriend(input:{sentToId:$sentToId}){
          success
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