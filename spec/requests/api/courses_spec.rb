# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/courses' do
  path '/courses' do
    get 'retrieves list' do
      tags 'Courses'
      produces 'application/json'
      consumes 'application/json'

      response '200', 'courses retrieves' do
        schema '$ref' => '#/components/schemas/course_list'
        let!(:courses) { create_list(:course, 5) }

        run_test! do
          expect(json_body[:count]).to eq(5)
          expect(json_body[:items].pluck(:id)).to match_array(courses.map(&:id))
        end
      end
    end

    post 'creates a course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, required: true },
          author_id: { type: :integer, required: true },
          competences_ids: { type: :array, items: { type: :integer }, required: true }
        }
      }

      response '201', 'course created' do
        schema '$ref' => '#/components/schemas/course_entity'
        let(:author) { create(:author) }
        let(:competence) { create(:competence) }
        let(:params) { { title: 'new course', author_id: author.id, competences_ids: [competence.id] } }

        run_test! do
          expect(json_body).to include(title: 'new course', author: author.slice(:id, :name))
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#components/schemas/error_entity'
        let(:params) { { title: 'foo' } }

        run_test! do
          expect(json_body[:errors]).to include(author_id: ['is missing'])
        end
      end

      response '422', 'author not exists' do
        schema '$ref' => '#components/schemas/error_entity'
        let(:params) { { author_id: 999 } }

        run_test! do
          expect(json_body[:errors]).to include(author_id: ['not exists'])
        end
      end

      response '422', 'competence not exists' do
        schema '$ref' => '#components/schemas/error_entity'
        let!(:competence) { create(:competence) }
        let(:params) { { competences_ids: [competence.id, 999, 666] } }

        run_test! do
          expect(json_body[:errors]).to include(competences_ids: { '1' => ['not exists'], '2' => ['not exists'] })
        end
      end
    end
  end

  path '/courses/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'retrieves course' do
      tags 'Courses'
      produces 'application/json'

      response '200', 'course retrieves' do
        schema '$ref' => '#/components/schemas/course_entity'
        let(:course) { create(:course) }
        let(:id) { course.id }

        run_test! do
          expect(json_body).to include(course.slice(:id, :title))
        end
      end

      response '404', 'course not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    delete 'delete course' do
      tags 'Courses'
      produces 'application/json'

      response '200', 'course removed' do
        schema '$ref' => '#/components/schemas/course_entity'
        let(:competence) { create(:competence) }
        let(:course_1) { create(:course, competences: [competence]) }
        let(:course_2) { create(:course, competences: [competence]) }
        let(:id) { course_1.id }

        run_test! do
          expect(json_body).to include(course_1.slice(:id, :title))
          expect(Course.find_by(id:)).to be_nil
          expect(CourseCompetence.where(course_id: id)).to be_empty
          expect(CourseCompetence.where(course_id: course_2.id).count).to eq(1)
        end
      end

      response '404', 'course not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    put 'updates course' do
      tags 'Courses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          author_id: { type: :integer },
          competences_ids: { type: :array, items: { type: :integer } }
        }
      }

      response '200', 'course updated' do
        schema '$ref' => '#/components/schemas/course_entity'
        let(:new_author) { create(:author) }
        let(:new_competence) { create(:competence) }
        let(:course) { create(:course) }
        let(:params) { { title: 'new course title', author_id: new_author.id, competences_ids: [new_competence.id] } }
        let(:id) { course.id }

        run_test! do
          expect(course.reload.attributes.symbolize_keys).to include(title: 'new course title',
                                                                     author_id: new_author.id)
          expect(course.competences).to include(new_competence)
        end
      end

      response '404', 'course not found' do
        schema '$ref' => '#components/schemas/error_404'
        let(:params) { {} }
        let(:id) { 999 }

        run_test!
      end
    end
  end
end
