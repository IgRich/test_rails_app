# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.timestamps

      t.references :author
    end
  end
end
