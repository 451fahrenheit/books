module Types
  class QueryType < Types::BaseObject

    field :titles, resolver: Queries::Titles,
      description: "Searches for book titles"
    
    field :title, resolver: Queries::Title,
      description: "Searches for book with volume id"

    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

  end
end
