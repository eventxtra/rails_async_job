# frozen_string_literal: true

require 'spec_helper'

describe RailsAsyncJob do
  with_model :TestJob do
    table do |t|
      t.string :job_id
      t.string :status
      t.string :type
      t.jsonb :json_attributes, default: {}

      t.timestamps null: false
    end

    model do
      include RailsAsyncJob
    end
  end

  it 'has the module' do
    expect(TestJob.include?(RailsAsyncJob)).to eq true
  end

  describe '.check_precondition' do
    subject { TestJob.new }

    it 'runs .with_terminator' do
      expect(subject).to receive(:with_terminator).once
      subject.check_precondition
    end

    context 'when status is :pending' do
      subject { TestJob.new(status: :pending) }

      it 'does not throw :abort' do
        expect do
          subject.check_precondition
        end.not_to throw_symbol :abort
      end
    end

    context 'when status is not :pending' do
      subject { TestJob.new(status: :working) }

      it 'throws :abort' do
        expect do
          subject.check_precondition
        end.to throw_symbol :abort
      end
    end
  end

  describe '.perform' do
    it 'raises exception by default' do
      expect do
        TestJob.new.perform
      end.to raise_error 'perform not undefined for job TestJob'
    end

    context 'when sub-class overrides this method' do
      before do
        stub_const('TextJobSubclass', Class.new(TestJob) do
          def self.name
            'TextJobSubclass'
          end

          def perform
            'hello'
          end
        end)
      end

      it 'works' do
        expect(TextJobSubclass.new.perform).to eq 'hello'
      end
    end

    context 'when sub-class does not override this method' do
      before do
        stub_const('TextJobSubclass', Class.new(TestJob) do
          def self.name
            'TextJobSubclass'
          end
        end)
      end

      it 'raises exception' do
        expect do
          TextJobSubclass.new.perform
        end.to raise_error 'perform not undefined for job TextJobSubclass'
      end
    end
  end
end
