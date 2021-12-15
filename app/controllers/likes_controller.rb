class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_like

  def index
    likes = Like.where(user_id: @user.id).pluck(:food_id)
    @like_foods = Food.find(likes)
  end

  def create
    user = current_user   # いいねするユーザーであるcurrent_userを変数userに格納
    food = Food.find(params[:food_id]) # いいねされた投稿のidとFoodテーブルのidが一致するものをfindで見つけて変数foodに格納
    like = Like.create(user_id: user.id, food_id: food.id)  # user_idが、先ほどcurrent_userを格納した変数userのidで、food_idが、いいねされたFoodテーブルのidを格納した変数food
  end

  def destroy
    user = current_user # いいねするユーザーであるcurrent_userを変数userに格納
    food = Food.find(params[:food_id]) # いいねされた投稿のidとFoodテーブルのidが一致するものをfindで見つけて変数foodに格納
    like = Like.find_by(user_id: user.id, food_id: food.id) # find_byで、user_idがcurrent_userのidと一致するもの且つ、food_idがいいねされたfoodのidと一致するものを探して、変数likeに格納します。
    like.delete  # likeを削除
  end

  private

  def set_like
    @food = Food.find(params[:food_id])
  end
end
