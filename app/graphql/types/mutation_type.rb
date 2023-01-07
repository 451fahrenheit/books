module Types
  class MutationType < Types::BaseObject
    
    field :create_user, mutation: Mutations::CreateUser
    field :login_user, mutation: Mutations::LoginUser
    field :add_book, mutation: Mutations::AddBook
    field :update_book, mutation: Mutations::UpdateBook
    field :add_friend, mutation: Mutations::AddFriend
    field :update_friend, mutation: Mutations::UpdateFriend
    field :test_field, String, null: false,
    
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
