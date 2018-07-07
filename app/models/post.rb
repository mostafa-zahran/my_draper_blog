class Post < ApplicationRecord
  validates_presence_of :title, :short_description, :content

  belongs_to :creator, foreign_key: :creator_id, class_name: 'User'
end