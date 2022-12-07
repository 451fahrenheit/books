class Book < ApplicationRecord
  validates :volumeId, presence: true
  belongs_to :user

  def serialize_authors(authors)
    serialized_authors = authors.join(',')
    serialized_authors
  end
  
  def deserialize_authors(authors)
    deserialized_authors = authors.split(',')
    deserialized_authors
  end
end

