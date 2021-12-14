class AddUserIdToFood < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :user_id, :integer
  end
end
