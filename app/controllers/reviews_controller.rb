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
      @food = Food.find(params[:id])
      render 'foods/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:food_id, :score, :content)
  end
end
