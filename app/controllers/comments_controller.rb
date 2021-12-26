class CommentsController < ApplicationController
  def create
    @food = Food.find(params[:food_id])
    @comment = @food.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment_food = @comment.food
    if @comment.save
      #通知の作成
      @comment_food.create_notification_comment!(current_user, @comment.id)
      redirect_to request.referer
    else
      @error_comment = @comment #＠error_commentにエラー内容を含んだcommentを再定義
      #renderでfood/showを表示させるため必要の定義を記入
      @food = Food.find(params[:food_id])
      @review = Review.new # レビュー新規作成に使用
      @error_review = @review #コメントエラー時ビューを表示させるために記載
      @reviews = @food.reviews #レビュー一覧表示のために定義
      @comment = Comment.new
      @comments = @food.comments # 投稿に対する全てのコメントを取得
      flash.now[:danger] = "コメント投稿に失敗しました"
      render "foods/show"
    end
  end

  def destroy
    @food = Food.find(params[:food_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
