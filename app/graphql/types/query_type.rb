module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :titles, String, null: false do
      argument :search_title, String, required: false
    end
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    def titles(search_title:)
      url= "https://www.googleapis.com/books/v1/volumes?q=#{search_title}+inauthor:keyes&key=AIzaSyARN9oEzSSmfhWShnXHgFyT0P48gdGjiBw"
      response = RestClient.get(url)      
      "Hello World!"
    end
  end
end
