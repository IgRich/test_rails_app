# frozen_string_literal: true

module Authors
  class CreateForm < ApplicationForm
    params do
      required(:name).value(:string)
    end
  end
end
