module Queries
  class GetUserBookWithTitle < Queries::BaseQuery

    argument :title, String, required: false
 
    type [Types::BookType], null: false

    def resolve(title:)
      user = context[:current_user]

      bookDTO=[]

      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      
      books = Book.where(user_id: user.id, title: title)
      if(books.count>0)

        books.each do |book|
          each_book = {}
          each_book['id'] = book.id
          each_book['volumeId'] = book.volumeId
          each_book['title'] = book.title
          each_book['subtitle'] = book.subtitle
          each_book['description'] = book.description
          each_book['language'] = book.language
          each_book['pubDate'] = book.pubDate
          each_book['thumbnail'] = book.thumbnail
          each_book['smallthumbnail'] = book.smallthumbnail
          each_book['user_id'] = book.user_id
          each_book['authors'] = Book.new.deserialize_authors(book.authors)
          each_book['is_public'] = book.is_public

          bookDTO << each_book
      
        end
      end
      bookDTO
    end
  end
end