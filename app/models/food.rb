class Food < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  attachment :image
end
