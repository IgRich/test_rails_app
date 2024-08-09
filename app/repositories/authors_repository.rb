# frozen_string_literal: true

class AuthorsRepository < BaseRepository
  NewAuthorNotFound = Class.new(StandardError)
  self.model = Author

  def destroy(id)
    author = show(id)
    replace_courses_author(author)
    author.destroy!
  end

  private

  def replace_courses_author(author)
    return if author.courses.empty?

    new_author = model.where.not(id: author.id).first
    raise NewAuthorNotFound if new_author.nil?

    author.courses.update(author: new_author)
  end
end
