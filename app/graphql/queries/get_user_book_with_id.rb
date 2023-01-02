module Queries
  class GetUserBookWithId < Queries::BaseQuery

    argument :id, ID, required: false
 
    type Types::BookType, null: false

    def resolve(id:)
      user = context[:current_user]
      bookDTO = {}
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      book = Book.find_by(id: id)
      if book
        bookDTO['id'] = book.id
        bookDTO['volumeId'] = book.volumeId
        bookDTO['title'] = book.title
        bookDTO['subtitle'] = book.subtitle
        bookDTO['description'] = book.description
        bookDTO['language'] = book.language
        bookDTO['pubDate'] = book.pubDate
        bookDTO['thumbnail'] = book.thumbnail
        bookDTO['smallthumbnail'] = book.smallthumbnail
        bookDTO['user_id'] = book.user_id
        bookDTO['authors'] = Book.new.deserialize_authors(book.authors)
        bookDTO['is_public'] = book.is_public
      else
        
        return GraphQL::ExecutionError.new('No Book Found')
        
      end
      bookDTO
    end

  end
end