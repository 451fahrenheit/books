require "rails_helper"
module Mutations
  RSpec.describe 'AddBook', type: :request do
    
    it "add new book to the user" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")

      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      jsonResponse = JSON.parse(response.body)
      post '/graphql', params: {query: query, variables:{
        volumeId:"alpha123",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1"
      }}

      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse.dig("data", "addBook","book","id")).to eq("1")
    end
    it "throws an error saying book already exists" do

      user = User.create!(email: "cultsharing@email.com", password: "12345678")
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

      post '/graphql', params: {query: query, variables:{
        volumeId:"alpha",
        title:"title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1"
        }}
        
        jsonResponse = JSON.parse(response.body)
        expect(jsonResponse["errors"].first["message"]).to eq('Book exists in the user library')
    end
    
    def query
      <<~GRAPHQL
      mutation AddBook {
        addBook(input: {addBook: {volumeId: "goodbook", title: "alpha", subtitle: "alpha", description: "alpha", authors: ["alpha", "beta"], smallthumbnail: "alpha", thumbnail: "alpha", language: "alpha", pubDate: "alpha"}}) {
          book {
            id
            volumeId
            title
            userId
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