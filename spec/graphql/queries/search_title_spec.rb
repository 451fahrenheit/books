require 'rails_helper'
module Queries
  RSpec.describe 'SearchTitle', type: :request do

    it "Fetches books for entered search title" do
      search_title = "Flowers"

      post '/graphql', params: { query: query, variables: {search_title: "cultsharing@email.com"} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse).not_to be_nil
    end
    it "returns error when no input is provided" do
      search_title = "Flowers"

      post '/graphql', params: { query: query, variables: {search_title: ""} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Enter text to search.")
    end

    def query
      <<~GRAPHQL
      query Titles($search_title: String!) {
        titles(searchTitle:$search_title){
          volumeId
          title
          subtitle
          description
          authors
          language
          pubDate
          smallthumbnail
          thumbnail
        }
        }
      GRAPHQL
    end
  end
end