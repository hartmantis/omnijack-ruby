# Encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/package/metadata/version'

Gem::Specification.new do |spec|
  spec.name          = 'chef-package-metadata'
  spec.version       = Chef::Package::Metadata::VERSION
  spec.authors       = ['Jonathan Hartman']
  spec.email         = %w(j@p4nt5.com)
  spec.summary       = 'Get Chef package metadata in Ruby'
  spec.description   = 'Get Chef package metadata in Ruby'
  spec.homepage      = 'https://rubygems.org/gems/chef-package-metadata'
  spec.license       = 'Apache v2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
