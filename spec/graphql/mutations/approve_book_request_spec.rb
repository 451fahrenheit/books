require "rails_helper"
module Mutations
  RSpec.describe 'ApproveBookRequest', type: :request do
    
    it "Approves a book request" do
      user = User.create!(email: "cultsharing@email.com", password: "12345678")
      user1 = User.create!(email: "Hello@email.com", password: "12345678")
      book = Book.create!(volumeId:"goodbook",
        title:"Test-title1",
        subtitle:"subtitle",
        description:"desc",
        authors:["a", "b"],
        language:"eng",
        pubDate:"12-12-2022",
        smallthumbnail: "img2",
        thumbnail: "image1",
        user: user
      )
      friendshp = Friendship.create!(
        sent_by_id: user1.id,
        sent_to_id: user.id,
        status: true
      )
      BookRequest.create!(
        sent_by_id: user1.id,
        sent_to_id: user.id,
        sent_for_id: book.id
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentById: user1.id,
        sentForId: book.id,
        approve: true
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["data"]["approveBookRequest"]["success"]).to eq(true)
    end
    it "Throws an error when the request does not exist" do
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
        user: user1
      )
      friendshp = Friendship.create!(
        sent_by_id: user1.id,
        sent_to_id: user.id,
        status: true
      )


      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: {query: query, variables:{
        sentById: user1.id,
        sentForId: book.id,
        approve: true
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Request does not exist")
    end
    it "returns Unauthorized when user is not signed in" do
      user=User.create!(email: "cultsharing@email.com", password: "12345678")

      post '/graphql', params: {query: query, variables:{
        sentById: user.id,
        sentForId: 1,
        approve: true
      }}
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Unauthorized")
    end
    
    def query
      <<~GRAPHQL
      mutation ApproveBookRequest($sentById: ID!,$sentForId: ID!){
        approveBookRequest(input:{ sentById:$sentById, sentForId:$sentForId, approve: true}){
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