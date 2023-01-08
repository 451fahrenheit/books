module Mutations
  class RequestBook < BaseMutation
    argument :sent_to_id, ID, required: false
    argument :sent_for_id, ID, required: false

    field :success, Boolean, null: true

    def resolve(sent_to_id: nil, sent_for_id: nil)

      user = context[:current_user]
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      sent_to_user = User.where(id: sent_to_id)
      unless sent_to_user.exists?
        return GraphQL::ExecutionError.new('Requested user does not exist')
      end
      book = Book.where(id: sent_for_id)
      unless book.exists?
        return GraphQL::ExecutionError.new('Requested book does not exist')
      end
      friendship = Friendship.where(sent_by_id: user.id,
                                  sent_to_id: sent_to_id,
                                status: true)
      unless friendship.exists?
        return GraphQL::ExecutionError.new('You are not friends with the user')
      end
      books = Book.where(user_id: sent_to_id, is_public: true)
    
      unless books.exists?
        return GraphQL::ExecutionError.new('User does not own the requested book')
      end
      BookRequest.create!(
        sent_by_id: user.id,
        sent_to_id: sent_to_id,
        sent_for_id: sent_for_id
      )
      {success: true}
    end
  end
end