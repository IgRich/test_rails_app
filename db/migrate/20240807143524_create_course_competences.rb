# frozen_string_literal: true

class CreateCourseCompetences < ActiveRecord::Migration[7.1]
  def change
    create_table :course_competences do |t|
      t.references :course
      t.references :competence
      t.timestamps
    end
  end
end
