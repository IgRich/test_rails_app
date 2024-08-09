# frozen_string_literal: true

class CreateCompetences < ActiveRecord::Migration[7.1]
  def change
    create_table :competences do |t|
      t.string :title
      t.timestamps
    end
    add_index :competences, :title, unique: true
  end
end
