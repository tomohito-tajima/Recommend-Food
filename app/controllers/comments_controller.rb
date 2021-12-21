class CommentsController < ApplicationController
  def create
    @food = Food.find(params[:food_id])
    @comment = @food.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to request.referer
    else
      @food_new = Food.new
      @comments = @food.comments
      redirect_to new_food_path
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
