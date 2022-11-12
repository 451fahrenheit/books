require "rails_helper"
module Mutations
    RSpec.describe 'CreateUser', type: :request do
      it "creates new user" do
        post '/graphql', params: { query: query, variables: {
					email: "cultsharing@email.com",
					password: "12345678"} }
				jsonResponse = JSON.parse(response.body)
	    	expect(jsonResponse.dig("data", "createUser", "user", "id")).to eq("1")
				expect(1).to eq(1)
      end
			it "doesn't allow to create user with existing email" do
				User.create!(email: "cultsharing@email.com", password: "12345678")

        post '/graphql', params: { query: query, variables: {email: "cultsharing@email.com", password: "12345678"} }

				jsonResponse = JSON.parse(response.body)

	    	expect(jsonResponse["errors"].first["message"]).to eq("Account already exists with this email.")
      end


  		def query
  		  <<~GRAPHQL
					mutation CreateUser($email: String!, $password: String!){
						createUser(input: {authProvider: {credentials: {email: $email, password: $password}}}) {
							user {
								id
								email
							
						}
					}				
				}
  		  GRAPHQL
  		end
  	end
end
		