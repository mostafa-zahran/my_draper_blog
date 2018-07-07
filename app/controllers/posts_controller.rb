class PostsController < ApplicationController
  include CommonBehavior

  skip_before_action :authenticate_user!, only: :index

  private

  def resource_class
    Post
  end

  def presenter
    Presenters::PostPresenter
  end

  def service_repository
    Services::Posts
  end

  def allowed_params
    @allowed_params ||= params.require(:post).permit(:title, :short_description, :content).merge({creator_id: current_user.id})
  end

  def resource
    @resource ||= resource_class.find_by_id(params[:id])
  end

  def ensure_resource
    redirect_to root_path unless resource
  end
end