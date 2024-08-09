class AuthorEntity < BaseEntity
  def format
    model.slice(:id, :name)
  end
end
