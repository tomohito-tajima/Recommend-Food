class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 投稿用のモデルとのアソシエーション
  has_many :foods, dependent: :destroy
  # いいね機能用のモデルとのアソシエーション
  has_many :likes, dependent: :destroy
  has_many :like_foods, through: :likes, source: :food
  # レビュー機能用のモデルとのアソシエーション
  has_many :reviews, dependent: :destroy
  # フォローをした、されたの関係
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # コメントモデルとのアソシエーション
  has_many :comments, dependent: :destroy
  # 通知モデルとの紐付け
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # 検索方法の分岐
  def self.looks(search, word)
    @user = if search == 'perfect_match'
              User.where('name LIKE?', word.to_s)
            elsif search == 'forward_match'
              User.where('name LIKE?', "#{word}%")
            elsif search == 'backward_match'
              User.where('name LIKE?', "%#{word}")
            elsif search == 'partial_match'
              User.where('name LIKE?', "%#{word}%")
            else
              User.all
            end
  end

  attachment :profile
end
