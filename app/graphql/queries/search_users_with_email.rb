module Queries
  class SearchUsersWithEmail < Queries::BaseQuery
    argument :search_email, String, required: true

    type [Types::UserType], null: false

    def resolve(search_email:)
      user = context[:current_user]
      wildcard_search = "%#{search_email}%"

      unless user
        return GraphQL::ExecutionError.new('Unauthorized')
      end

      userResponse = []
      users = User.where("email LIKE :search",search: wildcard_search)

      unless users.count>0
        return GraphQL::ExecutionError.new('Users does not exist')
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