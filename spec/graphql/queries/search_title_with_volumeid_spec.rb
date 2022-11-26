require 'rails_helper'
module Queries
  RSpec.describe 'SearchTitleWithvolumeid', type: :request do

    it "Fetches book for given volumeId" do
      volume_id = "zyTCAlFPjgYC"

      post '/graphql', params: { query: query, variables: {volume_id: volume_id} }
      jsonResponse = JSON.parse(response.body)
      volumeId = jsonResponse&.[]("data")&.[]("title")&.[]("volumeId")
      expect(volumeId).to eq(volume_id)
    end
    it "returns error when no input is provided" do
      search_title = "Flowers"

      post '/graphql', params: { query: query, variables: {volume_id: ""} }
      jsonResponse = JSON.parse(response.body)

      expect(jsonResponse["errors"].first["message"]).to eq("Selected volume does not exist.")
    end
    

    def query
      <<~GRAPHQL
      query Title($volume_id: String!) {
        title(volumeId:$volume_id){
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