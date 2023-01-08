module Mutations
  class ApproveBookRequest < BaseMutation
    argument :sent_by_id, ID, required: false
    argument :sent_for_id, ID, required: false
    argument :approve, Boolean, required: false

    field :success, Boolean, null: true

    def resolve(sent_by_id: nil, sent_for_id: nil, approve: nil)

      user = context[:current_user]
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      book_request = BookRequest.where(sent_to_id: user.id, sent_by_id: sent_by_id, sent_for_id: sent_for_id)
      unless book_request.exists?
        return GraphQL::ExecutionError.new('Request does not exist')
      end
      book_request = book_request.first
      book_request.status = approve
      book_request.save
      book = Book.find(sent_for_id)
      book.user_id = sent_by_id
      {success: true}
      #Todo implement roll back when the save is not successful
    end
  end
end