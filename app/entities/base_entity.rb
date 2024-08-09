class BaseEntity
  attr_reader :model

  def initialize(model)
    @model = model
  end

  def format
    raise NotImplementedError
  end
end
