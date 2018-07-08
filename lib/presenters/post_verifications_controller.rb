class PostVerificationsController < ApplicationController

  before_action :resource, :ensure_resource, only: :show

  def show
    session[:post_to_be_verified] = params[:id]
    service_repository::SendVerificationCode.new(authorized_resource_with_id.verification_code, current_user.phone)
  end

  def update
    obj = service_repository::Update.new({draft: false}, authorized_resource_with_code).call
    @result = {
        object: Presenters::Base.new(presenter, obj.success? ? obj.updated_object : authorized_resource_with_code.reload).result,
        success: obj.success?,
        errors: obj.errors
    }
    init_flash_messages('Updated Successfully')
    if request.xhr?
      render js: 'posts/update.js'
    else
      redirect_to resource_path(@result[:object][:id])
    end
  end

  private

  def service_repository
    Services::Posts
  end

  def authorized_resource_with_id
    @authorized_resource_with_id ||= Post.where(creator_id: current_user.id).find_by_id(params[:id])
  end

  def authorized_resource_with_code
    @authorized_resource_with_code ||= Post.where(creator_id: current_user.id).find_by_verification_code(params[:verification_code])
  end

  def ensure_resource
    redirect_to root_path if authorized_resource.blank?
  end

end