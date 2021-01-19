# frozen_string_literal: true

require 'rails/generators/active_record'

module RailsAsyncJob
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.join(__dir__, 'templates')

      argument :class_name

      def create_model_file
        template 'model.rb', "app/models/#{model_name}.rb"
      end

      def copy_migration
        migration_template(
          'migration.rb',
          "db/migrate/create_#{table_name}.rb",
          migration_version: migration_version
        )
      end

      def create_test_file
        template 'spec.rb', "spec/models/#{model_name}_spec.rb"
      end

      def model_name
        class_name.underscore
      end

      def table_name
        model_name.pluralize
      end

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
