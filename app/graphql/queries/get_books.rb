module Queries
  class GetBooks < Queries::BaseQuery

    type [Types::BookType], null: false

    def resolve
      user = context[:current_user]
      bookDTO=[]
      books = Book.where(user_id: user.id)
      books.each do |book|
        book_copy = {}
        book_copy['id'] = book.id
        book_copy['volumeId'] = book.volumeId
        book_copy['title'] = book.title
        book_copy['subtitle']=book.subtitle
        book_copy['description']=book.description
        book_copy['language']=book.language
        book_copy['pubDate']=book.pubDate
        book_copy['thumbnail']=book.thumbnail
        book_copy['smallthumbnail']=book.smallthumbnail
        book_copy['user_id']=book.user_id
        book_copy['authors'] = Book.new.deserialize_authors(book.authors)
        bookDTO << book_copy
      end
      bookDTO
    end
  end
end