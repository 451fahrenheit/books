module Mutations
  class AddFriend < BaseMutation
    argument :sent_to_id, ID, required: false

    field :success, Boolean, null: true

    def resolve(sent_to_id: nil)

      user = context[:current_user]
      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end
      sent_to_user = User.where(id: sent_to_id)

      unless sent_to_user.exists?
        return GraphQL::ExecutionError.new('Requested user does not exist')
      end
      Friendship.create!(
        sent_by_id: user.id,
        sent_to_id: sent_to_id
      )
      {success: true}
    end
  end
end