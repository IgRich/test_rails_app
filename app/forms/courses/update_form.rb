module Courses
  class UpdateForm < BaseForm
    params do
      required(:id).value(:integer)
      optional(:title).maybe(:string)
      optional(:author_id).maybe(:integer)
      optional(:competences_ids).maybe(:array?) { each(:integer, gt?: 0) }
    end

    rule(:author_id).validate(:author_exists?)
    rule(:competences_ids).each(:competences_exists?)
  end
end
