module Mutations
  class UpdateBook < BaseMutation

    argument :id, Integer, required: true
    argument :isPublic, Boolean, required: true

    field :book, Types::BookType, null: true

    def resolve(id: nil, isPublic: nil)
      user = context[:current_user]
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      book = Book.find_by(id: id, user_id: user.id)
      unless book
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      book.is_public = isPublic
      book.save
      {book: book}
      
    end
  end
end