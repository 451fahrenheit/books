module Types
  # AIzaSyARN9oEzSSmfhWShnXHgFyT0P48gdGjiBw
  class SearchTitleType < Types::BaseObject
    field :volume_id, String, null: false
    field :title, String, null: false
    field :subtitle, String, null: true
    field :description, String, null: true
    field :authors, [String], null: true
    field :language, String, null: false
    field :pub_date, String, null: false
    field :smallthumbnail, String, null: true
    field :thumbnail, String, null: true
  end
end