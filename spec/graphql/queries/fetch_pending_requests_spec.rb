require 'rails_helper'
module Queries
  RSpec.describe 'SearchUser', type: :request do

    it "Fetches users whose requests are pending" do
      
      search_text = "hello"
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "hello@email.com", password: "12345678")
      friendshp = Friendship.create!(
        sent_by_id: user.id,
        sent_to_id: user.id
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: fetch_pending_friend_requests}
      jsonResponse = JSON.parse(response.body)

      expect((jsonResponse["data"]["fetchPendingFriendRequests"]).count).to eq(1)

    end

    it "returns unauthotized when the user is not signed in" do
      
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      
      post '/graphql', params: { query: fetch_pending_friend_requests, variables: {search_email: 'alp'} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq('Unauthorized')

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
  
    def fetch_pending_friend_requests
      <<-GRAPHQL
      query FetchPendingFriendRequests{
        fetchPendingFriendRequests{
        id,
          email
        }
      
      }
      GRAPHQL
    end
  end
end