module Queries
  class Titles < Queries::BaseQuery
    argument :search_title, String, required: false


    type [Types::SearchTitleType], null: false


    def resolve(search_title:)
      unless search_title.to_s.strip.empty?
        url= "https://www.googleapis.com/books/v1/volumes?q=#{search_title}+&key=AIzaSyARN9oEzSSmfhWShnXHgFyT0P48gdGjiBw"
        response = RestClient.get(url)
        jsonResponse = JSON.parse(response)
        books = jsonResponse["items"]
        books_hash = []
        books.each do |book|
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
          
          books_hash.push(book_hash) 
        end   
        books_hash
      else
        return GraphQL::ExecutionError.new('Enter text to search.')
      end              
    end
  end
end