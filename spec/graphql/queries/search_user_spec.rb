require 'rails_helper'
module Queries
  RSpec.describe 'SearchUser', type: :request do

    it "Fetches users containing search text" do
      
      search_text = "hello"
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user=User.create!(email: "hello@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: search_users_with_email, variables: {search_email: search_text} }
      jsonResponse = JSON.parse(response.body)

      expect((jsonResponse["data"]["searchUsersWithEmail"]).count).to eq(1)

    end

    it "returns unauthotized when the user is not signed in" do
      
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      
      post '/graphql', params: { query: search_users_with_email, variables: {search_email: 'alp'} }
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
  
    def search_users_with_email
      <<-GRAPHQL
      query searchUsersWithEmail{
        searchUsersWithEmail(searchEmail: "hel"){
        id,
          email
        }
      
      }
      GRAPHQL
    end
  end
end