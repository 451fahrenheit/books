module Queries
  class GetBooks < Queries::BaseQuery

    type [Types::BookType], null: false

    def resolve
      user = context[:current_user]
      bookDTO=[]
      books = Book.where(user_id: user.id)

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
          bookDTO << each_book
      
        end
      bookDTO
    end
  end
end