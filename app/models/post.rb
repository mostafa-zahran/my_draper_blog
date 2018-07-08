class Post < ApplicationRecord
  include Verifiable

  validates_presence_of :title, :short_description, :content

  belongs_to :creator, foreign_key: :creator_id, class_name: 'User'
  scope :user_drafts, -> (user_id){ where(draft: true, creator_id: user_id) if user_id.present? }
end