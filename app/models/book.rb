class Book < ApplicationRecord
  validates :volumeId, presence: true
  belongs_to :user
  has_many :book_sent, class_name: 'BookRequest',
  foreign_key: 'sent_for_id',
  inverse_of: 'sent_by',
  dependent: :destroy

  def serialize_authors(authors)
    serialized_authors = authors.join(',')
    serialized_authors

  end
  
  def deserialize_authors(authors)
    deserialized_authors=[]
    if (authors!= nil) 
      split_authors = authors.split(',')
      split_authors.each do |author|
        deserialized_authors << author
      end
    end
    deserialized_authors
  end
end

