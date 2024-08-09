# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/competences' do
  path '/competences' do
    get 'retrieves list' do
      tags 'Competences'
      produces 'application/json'
      consumes 'application/json'

      response '200', 'competences retrieves' do
        schema '$ref' => '#/components/schemas/competence_list'
        let!(:competences) { create_list(:competence, 5) }

        run_test! do
          expect(json_body[:count]).to eq(5)
          expect(json_body[:items].pluck(:id)).to match_array(competences.map(&:id))
        end
      end
    end

    post 'creates a competence' do
      tags 'Competences'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, required: true }
        }
      }

      response '201', 'competences created' do
        schema '$ref' => '#/components/schemas/competence_entity'
        let(:params) { { title: 'new course' } }

        run_test! do
          expect(json_body).to include(title: 'new course')
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#components/schemas/error_entity'
        let(:params) { { not_title: 'foo' } }

        run_test! do
          expect(json_body[:errors]).to include(title: ['is missing'])
        end
      end

      response '422', 'competences already exists' do
        schema '$ref' => '#components/schemas/error_entity'
        let!(:competence) { create(:competence, title: 'new competence') }
        let(:params) { { title: 'new competence' } }

        run_test! do
          expect(json_body[:errors]).to include(title: ['already exists'])
        end
      end
    end
  end

  path '/competences/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'retrieves competence' do
      tags 'Competences'
      produces 'application/json'

      response '200', 'competence retrieves' do
        schema '$ref' => '#/components/schemas/competence_entity'
        let(:competence) { create(:competence) }
        let(:id) { competence.id }

        run_test! do
          expect(json_body).to include(competence.slice(:id, :title))
        end
      end

      response '404', 'competence not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    delete 'delete competence' do
      tags 'Competences'
      produces 'application/json'

      response '200', 'competence removed' do
        schema '$ref' => '#/components/schemas/competence_entity'
        let!(:competence) { create(:competence) }
        let(:id) { competence.id }

        run_test! do
          expect(json_body).to include(competence.slice(:id, :title))
          expect(Competence.find_by(id: competence)).to be_nil
        end
      end

      response '422', 'competence have relations' do
        schema '$ref' => '#components/schemas/error_entity'

        let!(:competence) { create(:competence) }
        let!(:course) { create(:course, competences: [competence]) }
        let(:id) { competence.id }

        run_test! do
          expect(json_body).to include(code: 'COMPETENCE_HAVE_COURSE')
        end
      end

      response '404', 'competence not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    put 'updates competence' do
      tags 'Competences'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, required: true }
        }
      }

      response '200', 'competence updated' do
        schema '$ref' => '#/components/schemas/competence_entity'
        let(:competence) { create(:competence) }
        let(:params) { { title: 'new competence title' } }
        let(:id) { competence.id }

        run_test! do
          expect(competence.reload.attributes.symbolize_keys).to include(title: 'new competence title')
        end
      end

      response '422', 'competences already exists' do
        schema '$ref' => '#components/schemas/error_entity'
        let!(:competence1) { create(:competence) }
        let!(:competence2) { create(:competence) }
        let(:params) { { title: competence2.title } }
        let(:id) { competence2.id }

        run_test! do
          expect(json_body[:errors]).to include(title: ['already exists'])
        end
      end

      response '404', 'competence not found' do
        schema '$ref' => '#components/schemas/error_404'
        let(:params) { { title: 'hello' } }
        let(:id) { 999 }

        run_test!
      end
    end
  end
end
