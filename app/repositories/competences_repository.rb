class CompetencesRepository < BaseRepository
  self.model = Competence

  CompetenceHaveCourse = Class.new(StandardError)

  def destroy(id)
    competence = show(id)
    raise CompetenceHaveCourse if competence.course_competences.exists?

    competence.destroy!
  end
end
