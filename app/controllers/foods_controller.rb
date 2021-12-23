class FoodsController < ApplicationController
  def new
    @food = Food.new
  end

  def create
    @food = current_user.foods.new(food_params)
    if @food.save
      # 新規投稿に成功したら詳細ページへ
      redirect_to food_path(@food.id)
      flash[:success] = '新規投稿しました。'
    else
      flash.now[:danger] = '新規投稿に失敗しました'
      render :new
    end
  end

  def index
    # kaminariを使用
    @foods = Food.all.page(params[:page]).per(5)
    #いいね数を表示させるために以下3行追加
    @user = current_user
    likes = Like.where(user_id: @user.id).pluck(:food_id)
    @like_foods = Food.find(likes)
  end

  def show
    @food = Food.find(params[:id])
    @review = Review.new # レビュー新規作成に使用
    @reviews = @food.reviews
    # コメント機能実装のための定義
    @comment = Comment.new
    @comments = @food.comments # 投稿に対する全てのコメントを取得
  end

  def edit
    @food = Food.find(params[:id])
    # カレントユーザでなければ編集できないように設定
    if @food.user == current_user
      render 'edit'
    else
      redirect_to foods_path
    end
  end

  def update
    @food = Food.find(params[:id])
    # 編集に成功すればshow画面にリダイレクト、失敗すればeditにレンダー
    if @food.update(food_params)
      redirect_to food_path(@food.id)
      flash[:success] = '投稿の編集に成功しました.'
    else
      flash.now[:danger] = '投稿の編集に失敗しました'
      render :edit
    end
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy
    redirect_to user_path(current_user)
    # カレントユーザでないと投稿を削除できない。
    # if @food.user != current_user
    #   redirect_to foods_path
    # else
    #   @food.destroy
    #   redirect_to user_path(current_user)
    # end
  end

  private

  # ストロングパラメータ
  def food_params
    params.require(:food).permit(:name, :genre, :menu, :price, :image, :address, :introduction)
  end
end
