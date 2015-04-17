$:.push File.expand_path("../lib", __FILE__)

require 'shariff_backend/version'

Gem::Specification.new do |s|
  s.name        = 'shariff_backend'
  s.version     = ShariffBackend::VERSION
  s.authors     = ['Marcus Ilgner']
  s.email       = ['mail@marcusilgner.com']
  s.homepage    = 'https://github.com/milgner/shariff_backend_ruby'
  s.summary     = 'Ruby/Rack-based backend for Shariff'
  s.description = 'Shariff is a privacy-friendly social sharing plugin by ' \
                  'german publisher Heise. ' \
                  'This is a backend written in Ruby so you can mount it in '\
                  'your Rack-based ruby app.'
  s.license     = 'MIT'

  s.files = Dir['lib/**/*', 'MIT-LICENSE']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'cuba', '~> 3.4.0'
  s.add_dependency 'httpclient', '~> 2.6.0'

  s.add_development_dependency 'bundler', '~> 1.9.4'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'cutest'
  s.add_development_dependency 'webmock'
end
