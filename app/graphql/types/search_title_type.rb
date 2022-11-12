module Types
  # AIzaSyARN9oEzSSmfhWShnXHgFyT0P48gdGjiBw
  class SearchTitleType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :author, String, null: false    
  end
end