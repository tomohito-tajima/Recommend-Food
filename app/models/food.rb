class Food < ApplicationRecord
  belongs_to :user
  # いいね機能用のモデルとのアソシエーション
  has_many :likes, dependent: :destroy
  # レビュー機能用のモデルとのアソシエーション
  has_many :reviews, dependent: :destroy
  # コメントモデルのアソシエーション
  has_many :comments, dependent: :destroy

  # レビューの平均値の定義
  def avg_score
    if reviews.empty?
      0.0
    else
      reviews.average(:score).round(1).to_f
    end
  end

  def review_score_percentage
    if reviews.empty?
      0.0
    else
      reviews.average(:score).round(1).to_f * 100 / 5
    end
  end

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # 検索方法分岐
  def self.looks(search, word)
    @food = if search == 'perfect_match'
              Food.where('name LIKE?', word.to_s)
            elsif search == 'forward_match'
              Food.where('name LIKE?', "#{word}%")
            elsif search == 'backward_match'
              Food.where('name LIKE?', "%#{word}")
            elsif search == 'partial_match'
              Food.where('name LIKE?', "%#{word}%")
            else
              Food.all
            end
  end

  attachment :image
end
