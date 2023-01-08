require 'rails_helper'
module Queries
  RSpec.describe 'FetchPendingFriendRequests', type: :request do

    it "Fetches pending book requests" do
      
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
      BookRequest.create!(
        sent_by_id: user1.id,
        sent_to_id: user.id,
        sent_for_id: book.id,
        status: false
      )
      post '/graphql', params: { query: signin_query, variables: {email: "cultsharing@email.com",password: "12345678"} }
      post '/graphql', params: { query: fetch_pending_book_requests}
      jsonResponse = JSON.parse(response.body)
      puts jsonResponse

      expect((jsonResponse["data"]["fetchPendingBookRequests"]).count).to eq(1)

    end

    it "returns unauthotized when the user is not signed in" do
      
      user=User.create!(email: "cultsharing@email.com", password: "12345678")
      
      post '/graphql', params: { query: fetch_pending_book_requests, variables: {search_email: 'alp'} }
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
  
    def fetch_pending_book_requests
      <<-GRAPHQL
      query FetchPendingBookRequests{
        fetchPendingBookRequests{
          id
          volumeId
          title
          subtitle
          description
          authors
          language
          pubDate
          smallthumbnail
          thumbnail
          isPublic
          requestedBy{
            id
            email
          }
        }
      
      }
      GRAPHQL
    end
  end
end