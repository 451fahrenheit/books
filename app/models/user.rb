class User < ApplicationRecord
    has_secure_password
    validates :email,  presence: true
    validates :password_digest,  presence: true
    has_many  :books

    has_many :friend_sent, class_name: 'Friendship',
                         foreign_key: 'sent_by_id',
                         inverse_of: 'sent_by',
                         dependent: :destroy
    has_many :friend_request, class_name: 'Friendship',
                         foreign_key: 'sent_to_id',
                         inverse_of: 'sent_to',
                         dependent: :destroy
    has_many :friends, -> { merge(Friendship.friends) },
            through: :friend_sent, source: :sent_to
    has_many :pending_requests, -> { merge(Friendship.not_friends) },
            through: :friend_sent, source: :sent_to
    has_many :received_requests, -> { merge(Friendship.not_friends) },
            through: :friend_request, source: :sent_by

end
