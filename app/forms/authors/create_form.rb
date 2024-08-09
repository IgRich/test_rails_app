module Authors
  class CreateForm < ApplicationForm
    params do
      required(:name).value(:string)
    end
  end
end
