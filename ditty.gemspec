# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ditty/version'

Gem::Specification.new do |spec|
  spec.name          = 'ditty'
  spec.version       = Ditty::VERSION
  spec.authors       = ['Jurgens du Toit']
  spec.email         = ['jrgns@jadeit.co.za']

  spec.summary       = 'Sinatra Based Application Framework'
  spec.description   = 'Sinatra Based Application Framework'
  spec.homepage      = 'https://github.com/eagerelk/ditty'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'racksh'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop'

  spec.add_dependency 'activesupport', '>= 3'
  spec.add_dependency 'bcrypt', '~> 3.1'
  spec.add_dependency 'haml', '~> 5.0'
  spec.add_dependency 'logger', '~> 1.0'
  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'omniauth-identity', '~> 1.0'
  spec.add_dependency 'pundit', '~> 1.0'
  spec.add_dependency 'rack-contrib', '~> 1.0'
  spec.add_dependency 'rake', '~> 12.0'
  spec.add_dependency 'sequel', '~> 4.0'
  spec.add_dependency 'sinatra', '~> 2.0'
  spec.add_dependency 'sinatra-contrib', '~> 2.0'
  spec.add_dependency 'sinatra-flash', '~> 0.3'
  spec.add_dependency 'tilt', '>= 2'
  spec.add_dependency 'wisper', '~> 2.0'
end
