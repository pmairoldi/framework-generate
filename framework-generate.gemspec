VERSION = '0.0.0'.freeze
DESCRIPTION = 'Tool to generate framework xcode projects'.freeze

Gem::Specification.new do |s|
  s.name        = 'framework-generate'
  s.version     = VERSION
  s.date        = '2016-01-02'
  s.summary     = DESCRIPTION
  s.description = DESCRIPTION
  s.authors     = ['Pierre-Marc Airoldi']
  s.email       = ['pierremarcairoldi@gmail.com']
  s.homepage    = 'https:/pierremarcairoldi.com'
  s.license     = 'MIT'
  s.files         = %w(README.md LICENSE) + Dir['lib/**/*.rb']
  s.executables   = %w(framework-generate)
  s.require_paths = %w(lib)
  s.required_ruby_version = '>= 2.0.0'
end
