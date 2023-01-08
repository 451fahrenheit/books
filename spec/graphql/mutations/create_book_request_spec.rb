require "rails_helper"
module Mutations
  RSpec.describe 'CreateBookRequest', type: :request do
    
    it "Creates a new book request" do
      user = User.create!(email: "cultsharing@email.com", password: "12345678")
      user1 = User.create!(email: "Hello@email.com", password: "12345678")
      book = Book.create!(volumeId:"goodbook",
        title:"Test-title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user1,
        is_public: true
      )
      Friendship.create!(
        sent_by_id: user.id,
        sent_to_id: user1.id,
        status: true
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentToId: user1.id,
        sentForId: book.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["data"]["requestBook"]["success"]).to eq(true)
    end

    it "Throws an error when the users are not friends" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")
      book = Book.create!(volumeId:"goodbook",
        title:"Test-title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user1
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      jsonResponse = JSON.parse(response.body)
      post '/graphql', params: {query: query, variables:{
        sentToId: user1.id,
        sentForId: book.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("You are not friends with the user")
    end

    it "Throws an error when the user does not exist" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")
      book = Book.create!(volumeId:"goodbook",
        title:"Test-title",
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
      jsonResponse = JSON.parse(response.body)
      post '/graphql', params: {query: query, variables:{
        sentToId: 2000,
        sentForId: book.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Requested user does not exist")
    end

    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      user1=User.create!(email: "Hello@email.com", password: "12345678")
      book = Book.create!(volumeId:"goodbook",
        title:"Test-title",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user1
      )
      post '/graphql', params: {query: query, variables:{
        sentToId: user1.id,
        sentForId: book.id
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    
    def query
      <<~GRAPHQL
      mutation RequestBook($sentToId: ID!,$sentForId: ID!){
        requestBook(input:{sentToId:$sentToId, sentForId:$sentForId}){
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