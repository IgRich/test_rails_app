# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_strict_schema_validation = true

  # Dynamic load schemas from #spec/components/schemas directory
  def load_schemas
    schemas_path = Rails.root.join('spec/components/schemas/').to_s
    schemas_files = Dir.glob("#{schemas_path}**/*")
    schemas_files = schemas_files.select { File.file?(_1) }
    schemas_files.reduce({}) do |acc, file|
      schema_path = file.sub(schemas_path, '').split('/')
      schema_path[-1] = schema_path[-1].sub('.json', '')
      schema_path << JSON.parse(File.read(file))
      schema = schema_path[0..-2].reverse.reduce(schema_path[-1]) { |b, a| { a => b } }.deep_symbolize_keys
      acc.deep_merge!(schema)
    end
  end

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://localhost:3000'
        }
      ],
      components: {
        schemas: load_schemas
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
  config.rswag_dry_run = false
end
