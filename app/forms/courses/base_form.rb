module Courses
  class BaseForm < ApplicationForm
    register_macro(:author_exists?) do
      next unless values.key?(key_name)

      key.failure('not exists') unless Author.exists?(value)
    end

    register_macro(:competences_exists?) do
      next unless values.key?(key_name)

      key.failure('not exists') unless Competence.exists?(value)
    end
  end
end
