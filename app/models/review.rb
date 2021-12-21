class Review < ApplicationRecord
  belongs_to :user
  belongs_to :food
  # レビューの星は必ず記入する設定
  validates :score, presence: true
end
