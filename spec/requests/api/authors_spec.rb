require 'swagger_helper'

RSpec.describe 'api/authors' do
  path '/authors' do
    get 'retrieves list' do
      tags 'Authors'
      produces 'application/json'
      consumes 'application/json'

      response '200', 'authors retrieves' do
        schema '$ref' => '#/components/schemas/author_list'
        let!(:authors) { create_list(:author, 5) }

        run_test! do
          expect(json_body[:count]).to eq(5)
          expect(json_body[:items].pluck(:id)).to match_array(authors.map(&:id))
        end
      end
    end

    post 'creates a author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :author, in: :body, schema: {
        type: :object,
        properties: { title: { type: :string } },
        required: ['title']
      }

      response '201', 'author created' do
        schema '$ref' => '#/components/schemas/author_entity'
        let(:author) { { name: 'foo' } }

        run_test! do
          expect(json_body).to include(name: 'foo')
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#components/schemas/error_entity'
        let(:author) { { title: 'foo' } }

        run_test! do
          expect(json_body[:errors]).to include(name: ['is missing'])
        end
      end
    end
  end

  path '/authors/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'retrieves author' do
      tags 'Authors'
      produces 'application/json'

      response '200', 'author retrieves' do
        schema '$ref' => '#/components/schemas/author_entity'
        let(:author) { create(:author) }
        let(:id) { author.id }

        run_test! do
          expect(json_body).to include(author.slice(:id, :name))
        end
      end

      response '404', 'author not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    delete 'delete author' do
      tags 'Authors'
      produces 'application/json'

      response '200', 'author removed' do
        schema '$ref' => '#/components/schemas/author_entity'
        let(:author) { create(:author) }
        let(:id) { author.id }

        run_test! do
          expect(json_body).to include(author.slice(:id, :name))
          expect(Author.find_by(id:)).to be_nil
        end
      end

      response '200', 'author replaces for courses' do
        schema '$ref' => '#/components/schemas/author_entity'
        let!(:author_1) { create(:author) }
        let!(:author_2) { create(:author) }
        let!(:course) { create(:course, author: author_1) }
        let(:id) { author_1.id }

        run_test! do
          expect(json_body).to include(author_1.slice(:id, :name))
          expect(course.reload.author).to eq(author_2)
        end
      end

      response '422', 'new author not found' do
        schema '$ref' => '#/components/schemas/error_entity'
        let!(:author) { create(:author) }
        let!(:course) { create(:course, author:) }
        let(:id) { author.id }

        run_test! do
          expect(course.reload.author).to eq(author)
        end
      end

      response '404', 'author not found' do
        schema '$ref' => '#/components/schemas/error_404'
        let(:id) { 999 }

        run_test! do
          expect(json_body).to include('code' => 'ENTITY_NOT_FOUND')
        end
      end
    end

    put 'updates author' do
      tags 'Authors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: { name: { type: :string } },
        required: ['title']
      }

      response '200', 'author updated' do
        schema '$ref' => '#/components/schemas/author_entity'
        let(:params) { { name: 'foo' } }
        let(:author) { create(:author) }
        let(:id) { author.id }

        run_test! do
          expect(json_body).to include(name: 'foo')
        end
      end

      response '422', 'invalid request' do
        schema '$ref' => '#components/schemas/error_entity'
        let(:params) { { not_name: 'foo' } }
        let(:author) { create(:author) }
        let(:id) { author.id }

        run_test! do
          expect(json_body[:errors]).to include(name: ['is missing'])
        end
      end
    end
  end
end
