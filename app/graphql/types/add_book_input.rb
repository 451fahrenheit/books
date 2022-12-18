module Types
  class AddBookInput < BaseInputObject
    graphql_name 'ADD_BOOK'

    argument :volumeId, String, required: true
    argument :title, String, required: false
    argument :subtitle, String, required: false
    argument :description, String, required: false
    argument :authors, [String], required: false
    argument :language, String, required: false
    argument :pubDate, String, required: false
    argument :smallthumbnail, String, required: false
    argument :thumbnail, String, required: false
  end
end