class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :volumeId
      t.string :title
      t.string :subtitle
      t.string :description
      t.string :authors
      t.string :language
      t.string :pubDate
      t.string :smallthumbnail
      t.string :thumbnail

      t.timestamps
    end
  end
end
