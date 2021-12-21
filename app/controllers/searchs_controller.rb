class SearchsController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == 'User'
      # looksメソッドを使い、検索内容を取得し、変数に代入します。
      @users = User.looks(params[:search], params[:word]) # インスタンス変数@usersにUserモデル内での検索結果を代入します。
    else
      @foods = Food.looks(params[:search], params[:word]) # インスタンス変数@foodsにFoodモデル内での検索結果を代入します。
    end
  end
end
