class BookRequest < ApplicationRecord
  belongs_to :sent_to, class_name: 'User', foreign_key: 'sent_to_id'
  belongs_to :sent_by, class_name: 'User', foreign_key: 'sent_by_id'
  belongs_to :sent_for, class_name: 'Book', foreign_key: 'sent_for_id'
end
