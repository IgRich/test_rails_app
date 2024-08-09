# frozen_string_literal: true

module Courses
  class CreateForm < BaseForm
    params do
      required(:title).value(:string)
      required(:author_id).value(:integer)
      required(:competences_ids).value(:array?) { each(:integer, gt?: 0) }
    end

    rule(:author_id).validate(:author_exists?)
    rule(:competences_ids).each(:competences_exists?)
  end
end
