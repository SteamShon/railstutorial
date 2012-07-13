class ReviewsController < ApplicationController
  def index
    @place = Place.find(params[:place])
    @reviews = Review.where(place_id: @place).paginate(page: params[:page])
  end

  def new
    @place_id = params[:place_id]
    @current_user = current_user
    @review = Review.new
  end

  def create
    #@review = Review.new(params[:review])
    @current_user = current_user
    #@review = @current_user.reviews.build(params[:review])
    if @current_user.reviews << Review.new(params[:review])
      flash[:notice] = "new post has been created."
      redirect_to current_user
    else
      render 'new'
    end
  end

  def show
    @current_user = current_user
    @review = Review.find(params[:id])
    respond_to do |format|
      format.js {
        @review.liked_by @current_user
      }
      format.html
    end
  end

  def toggle_rate
  end
end
