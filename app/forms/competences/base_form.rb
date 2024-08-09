module Competences
  class BaseForm < ApplicationForm
    register_macro(:competences_uniq?) do
      next unless values.key?(key_name)

      key.failure('already exists') if Competence.exists?(title: value)
    end
  end
end
