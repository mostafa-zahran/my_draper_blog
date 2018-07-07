class PostsController < ApplicationController

  before_action :post, :ensure_post, only: %i[edit show update destroy]
  before_action :post_params, only: %i[create update]
  skip_before_action :authenticate_user!, only: :index
  after_action :respond

  def index

  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def post_params
    @post_params ||= params.require(:post).permit(:title, :short_description, :content)
  end

  def post
    @post ||= Post.find_by_id(params[:id])
  end

  def ensure_post
    redirect_to root_path unless post
  end

  def respond
    respond_to do |format|
      request.xhr? ? format.json {render json: {result: @result}} : format.html
    end
  end
end