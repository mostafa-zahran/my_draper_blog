class PostVerificationsController < ApplicationController

  before_action :authorized_resource, :ensure_resource, only: [:show, :update]

  def show
    @result = Presenters::Base.new(presenter, authorized_resource).result
    service_repository::SendVerificationCode.new(authorized_resource.verification_code, current_user.phone).call
  end

  def update
    obj = service_repository::Update.new({draft: false}, authorized_resource).call
    @result = {
        object: Presenters::Base.new(presenter, obj.success? ? obj.updated_object : authorized_resource.reload).result,
        success: obj.success?,
        errors: obj.errors
    }
    init_flash_messages('Verified Successfully')
    if request.xhr?
      render js: 'posts/update.js'
    else
      redirect_to resource_path(@result[:object][:id])
    end
  end

  private

  def presenter
    Presenters::PostPresenter
  end

  def service_repository
    Services::Posts
  end

  def authorized_resource
    @authorized_resource ||= Post.find_by(allowed_params.merge({creator_id: current_user.id, draft: true}))
  end

  def allowed_params
    @allowed_params ||= params.permit(:id, :verification_code)
  end

  def ensure_resource
    if authorized_resource.blank?
      flash[:error] = 'Verified Code is not correct'
      redirect_to root_path
    end
  end

  def resource_path(id)
    post_path(id)
  end
end