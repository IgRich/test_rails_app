# frozen_string_literal: true

class Competence < ApplicationRecord
  has_many :course_competences, dependent: nil
  has_many :courses, through: :course_competences
end
