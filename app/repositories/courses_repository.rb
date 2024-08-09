# frozen_string_literal: true

class CoursesRepository < BaseRepository
  self.model = Course

  def list(**_params)
    model.includes(:author, :competences).all
  end

  def create(params)
    attributes = params.slice(:title, :author_id)
    competences = if params[:competences_ids].present?
                    Competence.where(id: params[:competences_ids])
                  else
                    []
                  end
    super(attributes.merge(competences:))
  end

  def update(id, params = {})
    attributes = params.slice(:title, :author_id)
    competences = if params[:competences_ids].present?
                    Competence.where(id: params[:competences_ids])
                  else
                    []
                  end
    super(id, attributes.merge(competences:))
  end
end
