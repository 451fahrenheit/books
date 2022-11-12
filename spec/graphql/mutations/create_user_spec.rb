require "rails_helper"
module Mutations
    RSpec.describe 'CreateUser', type: :request do
      it "creates new user" do
        post '/graphql', params: { query: query }
        puts response.body
        # result = B451Schema.execute(qs)
        # puts result["data"].dig("testField")

        expect(response.body.success).to eq(true)

      end
    
    	def query
    	    <<-GRAPHQL
					mutation type {
						createUser(input: {authProvider: {credentials: {email: "email@example.com", password: "123456"}}}) {
							user {
								id
								email
							}
							success
						}
					}					
    	    GRAPHQL
    	end
    end
end