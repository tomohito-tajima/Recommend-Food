class ReviewsController < ApplicationController
  def index
    @food = Food.find(params[:food_id])
    @reviews = @food.reviews
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @food = Food.find(params[:food_id])
    if @review.save
      redirect_to food_path(@food)
    else
      @error_review = @review #＠error_commentにエラー内容を含んだcommentを再定義
      #renderでfood/showを表示させるため必要の定義を記入
      @food = Food.find(params[:food_id])
      @review = Review.new # レビュー新規作成に使用
      @reviews = @food.reviews #レビュー一覧表示のために定義
      @comment = Comment.new
      @error_comment = @comment #レビューでエラー時にビューを表示させるために記載
      @comments = @food.comments # 投稿に対する全てのコメントを取得
      flash.now[:danger] = "レビュー投稿に失敗しました"
      render "foods/show"
    end
  end

  private

  def review_params
    params.require(:review).permit(:food_id, :score, :content)
  end
end
