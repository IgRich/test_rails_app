# frozen_string_literal: true

module Competences
  class CreateForm < BaseForm
    params do
      required(:title).value(:string)
    end

    rule(:title).validate(:competences_uniq?)
  end
end
