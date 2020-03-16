# frozen_string_literal: true

require_relative 'lib/auditapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'auditapi'
  spec.version       = AuditAPI::VERSION
  spec.authors       = ['AuditAPI']
  spec.email         = ['support@auditapi.com']

  spec.summary       = 'Ruby bindings for the AuditAPI API'
  spec.homepage      = 'https://github.com/auditapi/auditapi-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/auditapi/auditapi-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/auditapi/auditapi-ruby/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.18'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
