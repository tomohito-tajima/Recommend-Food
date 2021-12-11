class Food < ApplicationRecord

  belongs_to :user

  attachment :image

end
