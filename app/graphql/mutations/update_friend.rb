module Mutations
  class UpdateFriend < BaseMutation
    argument :sent_by_id, ID, required: false
    argument :approve, Boolean, required: false

    field :success, Boolean, null: true

    def resolve(sent_by_id: nil, approve: nil)

      user = context[:current_user]
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      friend_request = Friendship.where(sent_to_id: user.id, sent_by_id: sent_by_id)
      unless friend_request.exists?
        return GraphQL::ExecutionError.new('Request does not exist')
      end
      friend_request = friend_request.first
      friend_request.status = approve
      friend_request.save
      {success: true}
    end
  end
end