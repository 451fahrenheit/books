module Queries
  class SearchFriend < Queries::BaseQuery
    argument :search_email, String, required: true

    type [Types::UserType], null: false

    def resolve(search_email:)
      user = context[:current_user]
      wildcard_search = "%#{search_email}%"

      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      userResponse = []
      user = User.find(user.id)
      friends = user.friends.where("email LIKE :search",search: wildcard_search)

      unless friends.count>0
        return GraphQL::ExecutionError.new('Users does not exist')
      end

      friends.each do |friend|
        u = {}
        u["email"] = friend.email
        u["id"] = friend.id
        userResponse << u
      end

      userResponse
    end
  end
end