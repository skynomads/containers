require 'yaml'

Gem::Specification.new do |spec|
  spec.name        = 'common'
  spec.version     = YAML.load_file(File.join(__dir__, '..', 'common.yaml'))['package']['version']
  spec.summary     = ''
  spec.authors     = ['Jakob Gillich']
  spec.files       = Dir['lib/**/*']
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.add_runtime_dependency 'dry-configurable', '~> 0.15'
end
