require_relative 'lib/rails_async_job/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_async_job"
  spec.version       = RailsAsyncJob::VERSION
  spec.authors       = ["John Chan"]
  spec.email         = ["johnchan@eventxtra.com"]

  spec.summary       = %q{Rails lib for creating an ActiveRecord model to handle Sidekiq background jobs}
  spec.description   = %q{Rails lib for creating an ActiveRecord model to handle Sidekiq background jobs}
  spec.homepage      = "https://github.com/eventxtra/rails_async_job.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eventxtra/rails_async_job.git"
  spec.metadata["changelog_uri"] = "https://github.com/eventxtra/rails_async_job.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 5.2'
  spec.add_dependency 'attr_json', '>= 0.7'
  spec.add_dependency 'enumerize', '~> 2'
  spec.add_dependency 'sidekiq', '~> 6'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'with_model'
end
