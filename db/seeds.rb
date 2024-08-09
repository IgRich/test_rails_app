# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

competences = (1..30).map do |number|
  Competence.create!(title: "Competence in #{Faker::ProgrammingLanguage.name} ##{number}")
end

100.times do
  author = Author.create!(name: Faker::Name.name)
  author.courses.create!(
    title: "course #{Faker::ProgrammingLanguage.name}",
    competences: [competences.sample, competences.sample].uniq
  )
  author.courses.create!(
    title: "course #{Faker::ProgrammingLanguage.name}",
    competences: [competences.sample, competences.sample].uniq
  )
end
