class CreateBookRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :book_requests do |t|
      t.references :sent_to, null: false, foreign_key: { to_table: :users }
      t.references :sent_by, null: false, foreign_key: { to_table: :users }
      t.references :sent_for, null: false, foreign_key: { to_table: :books }
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
