class CourseEntity < BaseEntity
  def format
    result = model.slice(:id, :title)
    result[:author] = Formatter.item(AuthorEntity, model.author) if model.author.present?
    result[:competences] = model.competences.map { Formatter.item(CompetenceEntity, _1) }
    result
  end
end
