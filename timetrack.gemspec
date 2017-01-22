# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timetrack/version'

Gem::Specification.new do |spec|
  spec.name          = 'timetrack'
  spec.version       = Timetrack::VERSION
  spec.authors       = ['Jordan Ryan Reuter']
  spec.email         = ['me+timetrack@jreut.com']

  spec.summary       = 'Track your time in a file'
  spec.homepage      = 'https://www.github.com/jreut/timetrack'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'parslet', '~> 1.7.1'
  spec.add_dependency 'anima', '~> 0.3.0'
  spec.add_dependency 'thor', '~> 0.19.4'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-snapshot', '~> 0.1.1'
  spec.add_development_dependency 'devtools', '~> 0.1.16'
  spec.add_development_dependency 'pry'
end
