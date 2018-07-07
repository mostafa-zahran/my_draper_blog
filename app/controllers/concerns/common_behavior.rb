module CommonBehavior
  extend ActiveSupport::Concern

  included do
    before_action :resource, :ensure_resource, only: %i[edit show update destroy]
    before_action :allowed_params, only: %i[create update]
  end


  def index
    @result = {
        objects: Presenters::Base.new(presenter, service_repository::List.new.call).result
    }
  end

  def show
    @result = {object: Presenters::Base.new(presenter, resource).result}
  end

  def new
    @result = {object: Presenters::Base.new(presenter, resource_class.new).result}
  end

  def create
    obj = service_repository::Creat.new(allowed_params).call
    @result = {object: Presenters::Base.new(presenter, obj.created_object).result, success: obj.success?, errors: obj.errors}
  end

  def edit
    @result = {object: Presenters::Base.new(presenter, resource).result}
  end

  def update
    obj = service_repository::Update.new(allowed_params, resource).call
    @result = {object: Presenters::Base.new(presenter, obj.updated_object).result, success: obj.success?, errors: obj.errors}
  end

  def destroy
    obj = service_repository::Destroy.new(resource).call
    @result = {object: Presenters::Base.new(presenter, obj.destroyed_object).result, success: obj.success?, errors: obj.errors}
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

  def ensure_resource
    redirect_to root_path unless resource
  end
end