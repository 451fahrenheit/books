module Queries
  class FetchPendingFriendRequests < Queries::BaseQuery

    type [Types::UserType], null: false

    def resolve
      user = context[:current_user]

      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      userResponse = []
      users = User.find(user.id).received_requests

      unless users.count>0
        return GraphQL::ExecutionError.new('Currently user does not have any requests')
      end

      users.each do |user|
        u = {}
        u["email"] = user.email
        u["id"] = user.id
        userResponse << u
      end

      userResponse
    end
  end
end