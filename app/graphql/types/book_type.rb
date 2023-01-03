module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :volumeId, String, null: true
    field :title, String, null: true
    field :subtitle, String, null: true
    field :description, String, null: true
    field :authors, [String], null: true
    field :language, String, null: true
    field :pubDate, String, null: true
    field :smallthumbnail, String, null: true
    field :thumbnail, String, null: true
    field :user_id, String, null: true
    field :is_public, Boolean, null: true
  end

end
