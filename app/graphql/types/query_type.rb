module Types
  class QueryType < Types::BaseObject

    field :titles, resolver: Queries::Titles,
      description: "Searches for book titles"
    
    field :title, resolver: Queries::Title,
      description: "Searches for book with volume id"

    field :get_books, resolver: Queries::GetBooks,
      description: "Fetches all books from user's library"

    field :test_field, [String], null: false,
      description: "An example field added by the generator"

    field :get_user_book_with_title, resolver: Queries::GetUserBookWithTitle,
      description: "Searches and fetches a title"  
    
    field :get_user_book_with_id, resolver: Queries::GetUserBookWithId,
      description: "fetches a title by id"

    field :search_users_with_email, resolver: Queries::SearchUsersWithEmail,
      description: "fetches users by email"

    field :fetch_pending_friend_requests, resolver: Queries::FetchPendingFriendRequests,
      description: "fetches pending requests from users"

    field :fetch_friends, resolver: Queries::FetchFriends,
      description: "fetches friends"

    field :search_friend, resolver: Queries::SearchFriend,
      description: "fetches friends"

    def test_field
      ["Hello World!", "Bolo"]
    end

    # def get_user_book_with_id
    #   ["Hello"]
    # end




  end
end
