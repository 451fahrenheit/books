require "rails_helper"
module Mutations
    RSpec.describe 'LoginUser', type: :request do

      it "creates new user token when email exists and password is correct" do
				User.create!(email: "cultsharing@email.com", password: "12345678")

				post '/graphql', params: { query: query, variables: {email: "cultsharing@email.com",password: "12345678"} }
	    	jsonResponse = JSON.parse(response.body)

	      expect(jsonResponse.dig("data", "loginUser", "token")).not_to be_nil
      end

			it "throws password error when wrong password is entered" do			
				User.create!(email: "cultsharing@email.com", password: "1234567890")


				post '/graphql', params: { query: query, variables: {email: "cultsharing@email.com",password: "12345678"} }
			  jsonResponse = JSON.parse(response.body)

	  	  expect(jsonResponse["errors"].first["message"]).to eq("Incorrect password, check if capslock is on")
    	end

			it "throws account not found error when email entered doesn't exist" do			
				User.create!(email: "cultsharing@email.com", password: "123456789")

    	  post '/graphql', params: { query: query, variables: {email: "cultsharing1@email.com",password: "123456789"} }
			  jsonResponse = JSON.parse(response.body)

	  	  expect(jsonResponse["errors"].first["message"]).to eq("Account not found, create an account or check for spelling in existing")
    	end

    def query
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