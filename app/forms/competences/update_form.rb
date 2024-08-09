# frozen_string_literal: true

module Competences
  class UpdateForm < BaseForm
    params do
      required(:id).value(:integer)
      required(:title).value(:string)
    end

    rule(:title).validate(:competences_uniq?)
  end
end
