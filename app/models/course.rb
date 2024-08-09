class Course < ApplicationRecord
  belongs_to :author
  has_many :course_competences, dependent: :destroy
  has_many :competences, through: :course_competences
end
