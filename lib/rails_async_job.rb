# frozen_string_literal: true

require 'rails_async_job/version'
require 'active_record'
require 'active_support/concern'
require 'attr_json'
require 'enumerize'
require 'sidekiq'

module RailsAsyncJob
  class Error < StandardError; end

  extend ActiveSupport::Concern

  included do
    include AttrJson::Record
    extend Enumerize

    enumerize :status, in: %i[pending working completed failed], scope: true, default: :pending

    before_create :check_precondition
    after_commit :delay_perform, on: :create

    def delay_perform
      update job_id: self.class.delay.perform_job(id)
    end

    def perform_job
      with_terminator do
        update status: :working
        perform
        update status: :completed if status.working?
      end
      save if changed?
    end

    def check_precondition
      with_terminator { precondition }
      throw :abort unless status.pending?
    end

    def precondition
      # noop by default
    end

    def perform
      raise "perform not undefined for job #{self.class.name}"
    end

    private

    def with_terminator
      fail_thrown = true
      complete_thrown = true
      catch(:fail) do
        catch(:complete) do
          yield
          complete_thrown = false
        end
        fail_thrown = false
      end
      thrown = :complete if complete_thrown
      thrown = :fail if fail_thrown

      case thrown
      when :complete
        self.status = :completed
      when :fail
        self.status = :failed
      end
    end
  end

  class_methods do
    def perform_job(job_id)
      find(job_id)&.perform_job
    end
  end
end
