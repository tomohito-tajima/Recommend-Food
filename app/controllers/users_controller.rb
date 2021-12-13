class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @foods = @user.foods
    # @foods = Food.all
  end

  def index
    # @users = User.all
     @users = User.all.page(params[:page]).per(3)
    # @users = User.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit
     @user = User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:success] = "プロフィールを更新しました"
    else
      flash[:danger] = "プロフィールの更新に失敗しました"
      render :edit
    end
  end

  def user_params
    params.require(:user).permit(:name, :name_kana, :favorited_food, :profile, :introduction)
  end

end
