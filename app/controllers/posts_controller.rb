class PostsController < ApplicationController
  include CommonBehavior

  skip_before_action :authenticate_user!, only: :index
  before_action :can_verify?, only: :create

  def create
    obj = service_repository::Creat.new(allowed_params.merge({creator_id: current_user.id, draft: true})).call
    @result = {object: Presenters::Base.new(presenter, obj.created_object).result, success: obj.success?, errors: obj.errors}
    init_flash_messages('Created Successfully please verify post to publish it')
    redirect_to @result[:success] ? resource_path(@result[:object][:id]) : :back unless request.xhr?
  end

  private

  def can_verify?
    redirect_to edit_user_registration_path, error: 'Please enter your phone before continuing' if current_user.phone.blank?
  end

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
    @allowed_params ||= params.require(:post).permit(:title, :short_description, :content)
  end

  def resource
    @resource ||= resource_class.find_by_id(params[:id])
  end

  def ensure_resource
    redirect_to root_path unless resource
  end

  def resource_path(id)
    post_path(id)
  end

  def resources_path
    posts_path
  end
end