module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :create_user, mutation: Mutations::CreateUser
    field :login_user, mutation: Mutations::LoginUser

    field :test_field, String, null: false,
    
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
