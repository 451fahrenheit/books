module Mutations
  class AddBook < BaseMutation

    argument :add_book, Types::AddBookInput, required: false

    field :book, Types::BookType, null: true

    def resolve(add_book: nil)
      user = context[:current_user]
      book = Book.find_by(volumeId: add_book&.[](:volumeId), user_id: user.id)

      unless(book)
        authors=add_book&.[](:authors)
        serialized_authors = Book.new.serialize_authors(authors)
        book = Book.create!(
          volumeId: add_book&.[](:volumeId),
          title: add_book&.[](:title),
          subtitle: add_book&.[](:subtitle),
          description: add_book&.[](:description),
          authors: serialized_authors,
          language: add_book&.[](:language),
          pubDate: add_book&.[](:pubDate),
          smallthumbnail: add_book&.[](:smallthumbnail),
          thumbnail: add_book&.[](:thumbnail),
          user: user
        )
        book.authors=Book.new.deserialize_authors(book.authors)
        {book: book}
      
      else
        GraphQL::ExecutionError.new('Book exists in the user library')
      end

    end

  end
end