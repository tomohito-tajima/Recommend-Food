class Food < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  #コメントモデルのアソシエーション
  has_many :comments, dependent: :destroy

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @food = Food.where("name LIKE?","#{word}")
    elsif search == "forward_match"
      @food = Food.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @food = Food.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @food = Food.where("name LIKE?","%#{word}%")
    else
      @food = Food.all
    end
  end

  attachment :image
end
