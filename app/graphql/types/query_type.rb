module Types
  class QueryType < Types::BaseObject

    field :titles, resolver: Queries::Titles,
      description: "Searches for book titles"
    
    field :title, resolver: Queries::Title,
      description: "Searches for book with volume id"

    field :get_books, resolver: Queries::GetBooks,
      description: "Fetches all books from user's library"

    field :test_field, [String], null: false,
      description: "An example field added by the generator"
      
    def test_field
      ["Hello World!", "Bolo"]
    end



  end
end
