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
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy # active_notifications：自分からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy # passive_notifications：相手からの通知

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

  # 通知レコードを作成するためメソッド
  def create_notification_follow!(current_user)
    # 既に「フォロー」されているか検索（同じ通知レコードが存在しないときだけ、レコードを作成するようにする）
    temp = Notification.where(['visitor_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'follow'])
    # フォローされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  attachment :profile
  validates :name, presence: true
end
