class Message < ApplicationRecord
	belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :chat_room

  validates :body, presence: true

  default_scope { order('created_at ASC') }
end
