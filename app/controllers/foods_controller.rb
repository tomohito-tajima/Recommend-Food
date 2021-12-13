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
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  # ストロングパラメータ
  def food_params
    params.require(:food).permit(:name, :genre, :menu, :price, :image, :address, :introduction)
  end

end
