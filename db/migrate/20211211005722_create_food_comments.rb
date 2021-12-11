class CreateFoodComments < ActiveRecord::Migration[5.2]
  def change
    create_table :food_comments do |t|

      t.timestamps
    end
  end
end
