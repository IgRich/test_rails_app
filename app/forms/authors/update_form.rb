# frozen_string_literal: true

module Authors
  class UpdateForm < ApplicationForm
    params do
      required(:id).value(:integer)
      required(:name).value(:string)
    end
  end
end
