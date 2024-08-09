# frozen_string_literal: true

class ApplicationController < ActionController::API
  UnknownEntityFormat = Class.new(StandardError)
  UnprocessableEntityError = Class.new(StandardError) do
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super
    end
  end

  rescue_from BaseRepository::EntityNotFound, with: :error404
  rescue_from UnprocessableEntityError, AuthorsRepository::NewAuthorNotFound,
              CompetencesRepository::CompetenceHaveCourse, with: :error_handler

  protected

  def format_entities(entity_model, query)
    if query.is_a?(ActiveRecord::Base)
      Formatter.item(entity_model, query)
    elsif query.is_a?(ActiveRecord::Relation)
      Formatter.list(entity_model, query)
    else
      raise UnknownEntityFormat
    end
  end

  private

  def error404(error)
    error_code = error.class.name.demodulize.underscore.upcase
    render json: { code: error_code }, status: :not_found
  end

  def error_handler(error)
    error_code = error.class.name.demodulize.underscore.upcase
    errors = error.try(:errors) || {}
    render json: { code: error_code, errors: }, status: :unprocessable_entity
  end

  def validate_with(form, params, key = nil)
    params = params.to_unsafe_h unless params.is_a?(Hash)

    validation_result = form.new.call(key.nil? ? params : params[key])

    raise UnprocessableEntityError, validation_result.errors.to_h unless validation_result.success?

    validation_result.to_h
  end
end
