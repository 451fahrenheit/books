module Queries
  class Title < Queries::BaseQuery
    argument :volume_id, String, required: false


    type Types::SearchTitleType, null: false


    def resolve(volume_id:)
      unless volume_id.to_s.strip.empty?
        url = "https://www.googleapis.com/books/v1/volumes/#{volume_id}+?key=AIzaSyARN9oEzSSmfhWShnXHgFyT0P48gdGjiBw"
        response = RestClient.get(url)
        jsonResponse = JSON.parse(response)
        book = jsonResponse        

        book_hash={}
        book_hash["volume_id"] = book&.[]("id")
        book_hash["title"] = book&.[]("volumeInfo")&.[]("title")
        book_hash["subtitle"] = book&.[]("volumeInfo")&.[]("subtitle")
        book_hash["authors"] = book&.[]("volumeInfo")&.[]("authors")
        book_hash["pub_date"] = book&.[]("volumeInfo")&.[]("publishedDate")
        book_hash["description"] = book&.[]("volumeInfo")&.[]("description")
        book_hash["language"] = book&.[]("volumeInfo")&.[]("language")
        book_hash["smallthumbnail"]=book&.[]("volumeInfo")&.[]("imageLinks")&.[]("smallThumbnail")
        book_hash["thumbnail"]=book&.[]("volumeInfo")&.[]("imageLinks")&.[]("thumbnail")                    
        book_hash

      else
        return GraphQL::ExecutionError.new('Selected volume does not exist.')
      end              
    end
  end
end