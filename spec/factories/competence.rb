# frozen_string_literal: true

FactoryBot.define do
  factory :competence do
    title { "Competence in #{Faker::ProgrammingLanguage.name}" }
  end
end
