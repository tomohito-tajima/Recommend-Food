class AddContentToFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :content, :string
  end
end