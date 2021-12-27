class Food < ApplicationRecord
  belongs_to :user
  # いいね機能用のモデルとのアソシエーション
  has_many :likes, dependent: :destroy
  # レビュー機能用のモデルとのアソシエーション
  has_many :reviews, dependent: :destroy
  # コメントモデルのアソシエーション
  has_many :comments, dependent: :destroy
  # 通知モデルとのアソシエーション
  has_many :notifications, dependent: :destroy

  validates :name, presence: true # nameのデータがないと投稿できない
  validates :introduction, presence: true
  validates :image, presence: true # imageのデータがないと投稿できない

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

  # 通知メソッドの作成（ここから）
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      food_id: id,
      visited_id: user_id,
      action: 'like'
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(food_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      food_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
  # （ここまで）

  attachment :image
end
