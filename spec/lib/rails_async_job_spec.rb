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
        expect {
          subject.check_precondition
        }.to_not throw_symbol :abort
      end
    end

    context 'when status is not :pending' do
      subject { TestJob.new(status: :working) }

      it 'throws :abort' do
        expect {
          subject.check_precondition
        }.to throw_symbol :abort
      end
    end
  end

  describe '.perform' do
    it 'raises exception by default' do
      expect {
        TestJob.new.perform
      }.to raise_error 'perform not undefined for job TestJob'
    end

    context 'when sub-class overrides this method' do
      before do
        stub_const('TextJobSubclass', Class.new(TestJob) do
          def self.name
            'TextJobSubclass'
          end

          include RailsAsyncJob

          def perform
            'hello'
          end
        end)
      end

      it 'works' do
        expect(TextJobSubclass.new.perform).to eq 'hello'
      end
    end
  end
end
