class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # @foods = @user.foods
    @foods = @user.foods
  end

  def index
    # kaminariを使用
    @users = User.all.page(params[:page]).per(3)
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render 'edit'
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:success] = 'プロフィールを更新しました'
    else
      flash[:danger] = 'プロフィールの更新に失敗しました'
      render :edit
    end
  end

  # ストロングパラメータ
  private

  def user_params
    params.require(:user).permit(:name, :name_kana, :favorited_food, :profile, :introduction)
  end
end
