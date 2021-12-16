class AddEvaluationToFoods < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :evaluation, :float
  end
end
