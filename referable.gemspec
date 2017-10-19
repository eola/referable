# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "referable/version"

Gem::Specification.new do |spec|
  spec.name          = 'referable'
  spec.version       = Referable::VERSION
  spec.authors       = ['Daniel Steele']
  spec.email         = ['danielsteele@hotmail.co.uk']

  spec.summary       = 'Add a multi-tenant referral system to your app'
  spec.description   = 'Add a multi-tenant referral and rewards system to your app'
  spec.homepage      = 'https://github.com/eola/referable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
