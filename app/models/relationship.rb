class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User" #class_name: "User"でuserテーブルからデータをとってきてもらうようにする。
  belongs_to :followed, class_name: "User"
  
end
