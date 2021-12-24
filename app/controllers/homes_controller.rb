class HomesController < ApplicationController
  def top
    #foodランキング機能のため追記
    #Like.group(:food_id)・・最初に、記事の番号(food_id)が同じものにグループを分ける
    #order('count(food_id) desc')・・それを、番号の多い順に並び替える
    #limit(5)・・表示する最大数を5個に指定する
    #@all_rankspluck(:food_id)・・最後に:food_idカラムのみを数字で取り出すように指定。
    @all_ranks = Food.find(Like.group(:food_id).order('count(food_id) desc').limit(5).pluck(:food_id))
  end

  def about
  end
end
