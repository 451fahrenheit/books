require "rails_helper"
module Mutations
  RSpec.describe 'UpdateFriendRequest', type: :request do
    
    it "Approves a friend request" do
      user = User.create!(email: "cultsharing@email.com", password: "12345678")
      user1 = User.create!(email: "Hello@email.com", password: "12345678")
      friendshp = Friendship.create!(
        sent_by_id: user1.id,
        sent_to_id: user.id
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentById: user1.id,
        approve: true
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["data"]["updateFriend"]["success"]).to eq(true)
    end
    it "Throws an error when the request does not exist" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentById: 21,
        approve: true
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Request does not exist")
    end
    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")

      post '/graphql', params: {query: query, variables:{
        sentById: user.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    
    def query
      <<~GRAPHQL
      mutation UpdateFriend($sentById: ID!){
        updateFriend(input:{sentById:$sentById, approve: true}){
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