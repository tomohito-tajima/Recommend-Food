class FoodsController < ApplicationController

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      # 新規投稿に成功したら詳細ページへ
      redirect_to food_path(@food.id)
      flash[:success] = "新規投稿しました。"
    else
      flash.now[:danger] = "新規投稿に失敗しました"
      render :new
    end
  end

  def index
    # kaminariを使用
     @foods = Food.all.page(params[:page]).per(3)
  end

  def show
    @food = Food.find(params[:id])
  end

  def edit
    @food = Food.find(params[:id])
    #カレントユーザでなければ編集できないように設定
    if @food.user == current_user
      render "edit"
    else
      redirect_to foods_path
    end
  end

  def update
    @food = Food.find(params[:id])
    #編集に成功すればshow画面にリダイレクト、失敗すればeditにレンダー
    if @food.update(food_params)
      redirect_to food_path(@food.id)
      flash[:success] = "投稿の編集に成功しました."
    else
      flash.now[:danger] = "投稿の編集に失敗しました"
      render :edit
    end
  end

  def destroy
    @food = Food.find(params[:id])
    #カレントユーザでないと投稿を削除できない。
    if @food.user != current_user
      redirect_to foods_path
    else
      @food.destroy
      redirect_to foods_path
    end
  end

  private
  # ストロングパラメータ
  def food_params
    params.require(:food).permit(:name, :genre, :menu, :price, :image, :address, :introduction)
  end

end
