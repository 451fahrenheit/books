module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :volumeId, String, null: false
    field :title, String, null: false
    field :subtitle, String, null: false
    field :authors, String, null: false
    field :language, String, null: false
    field :pubDate, String, null: false
    field :smallthumbnail, String, null: false
    field :thumbnail, String, null: false
    field :user_id, String, null: false
  end

end
