# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    author
    title { "course #{Faker::ProgrammingLanguage.name}" }
  end
end
