class BaseRepository
  class_attribute :model

  EntityNotFound = Class.new(StandardError)

  def list(**_params)
    model.all
  end

  def show(id)
    model.find(id)
  rescue ActiveRecord::RecordNotFound
    raise EntityNotFound
  end

  def create(params)
    model.create(**params)
  end

  def update(id, params = {})
    instance = show(id)
    instance.update!(params)
    instance
  end

  def destroy(id)
    show(id).destroy!
  end
end
