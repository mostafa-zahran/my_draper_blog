module CommonBehavior
  extend ActiveSupport::Concern

  included do
    before_action :resource, :ensure_resource, only: :show
    before_action :authorized_resource, only: %i[edit update destroy]
    before_action :allowed_params, only: %i[create update]
  end


  def index
    objs = service_repository::List.new(params[:page].presence || 1, current_user&.id).call
    @result = {
        objects: Presenters::Base.new(presenter, objs.objects_list).result,
        has_more: objs.more?,
        current_page: objs.current_page
    }
  end

  def show
    @result = {object: Presenters::Base.new(presenter, resource).result}
  end

  def new
    @result = resource_class.new
  end

  def create
    obj = service_repository::Creat.new(allowed_params).call
    @result = {object: Presenters::Base.new(presenter, obj.created_object).result, success: obj.success?, errors: obj.errors}
    init_flash_messages('Created Successfully')
    redirect_to @result[:success] ? post_path(@result[:object][:id]) : :back unless request.xhr?
  end

  def edit
    @result = authorized_resource
  end

  def update
    obj = service_repository::Update.new(allowed_params, authorized_resource).call
    @result = {
        object: Presenters::Base.new(presenter, obj.success? ? obj.updated_object : authorized_resource.reload).result,
        success: obj.success?,
        errors: obj.errors
    }
    init_flash_messages('Updated Successfully')
    redirect_to resource_path(@result[:object][:id]) unless request.xhr?
  end

  def destroy
    obj = service_repository::Destroy.new(authorized_resource).call
    @result = {object: Presenters::Base.new(presenter, obj.destroyed_object).result, success: obj.success?, errors: obj.errors}
    init_flash_messages('Destroyed Successfully')
    redirect_to @result[:success] ? resources_path : :back unless request.xhr?
  end

  private

  def resource_class
    raise 'resource_class Have to be implemented'
  end

  def presenter
    raise 'presenter Have to be implemented'
  end

  def service_repository
    raise 'service_repository Have to be implemented'
  end

  def allowed_params
    raise 'allowed_params Have to be implemented'
  end

  def resource
    @resource ||= resource_class.find_by_id(params[:id])
  end

  def authorized_resource
    @authorized_resource ||= resource_class.where(creator_id: current_user.id).find_by_id(params[:id])
  end

  def ensure_resource
    redirect_to root_path if resource.blank? && authorized_resource.blank?
  end

  def resource_path(id)
    raise 'resource_path Have to be implemented'
  end

  def resources_path
    raise 'resources_path Have to be implemented'
  end
end