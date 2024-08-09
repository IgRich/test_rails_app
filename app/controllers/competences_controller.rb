# frozen_string_literal: true

class CompetencesController < ApplicationController
  def index
    render json: format_entities(CompetenceEntity, repository.list), status: :ok
  end

  def show
    author = repository.show(params[:id])
    render json: format_entities(CompetenceEntity, author), status: :ok
  end

  def create
    valid_params = validate_with(Competences::CreateForm, params)
    author = repository.create(valid_params)
    render json: format_entities(CompetenceEntity, author), status: :created
  end

  def update
    valid_params = validate_with(Competences::UpdateForm, params)
    author = repository.update(valid_params[:id], valid_params.except(:id))
    render json: format_entities(CompetenceEntity, author), status: :ok
  end

  def destroy
    author = repository.destroy(params[:id])
    render json: format_entities(CompetenceEntity, author), status: :ok
  end

  private

  def repository
    @repository ||= CompetencesRepository.new
  end
end
