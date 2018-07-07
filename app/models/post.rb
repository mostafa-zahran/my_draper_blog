class Post < ApplicationRecord
  validates_presence_of :title, :short_description, :content

  belongs_to :user, foreign_key: :creator_id
end