# frozen_string_literal: true

class CompetenceEntity < BaseEntity
  def format
    model.slice(:id, :title)
  end
end
