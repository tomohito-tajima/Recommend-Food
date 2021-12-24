class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }  #default_scopeでは、デフォルトの並び順を「新着順」で指定
  belongs_to :food, optional: true #optional: trueは、nilを許可する =>フォロー通知ではfood_idは関与しないためnilとなるので、このオプションをつけないとフォロー通知が有効にならない。
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
