# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitshares/version'

Gem::Specification.new do |s|
  s.name          = 'bitshares'
  s.version       = Bitshares::VERSION
  s.authors       = ['Bruce Steedman']
  s.email         = ['bruce.steedman@gmail.com']

  s.summary       = %q{Ruby API for BitShares CLI client}
  s.description   = %q{Ruby API for BitShares CLI client}
  s.license       = "MIT"

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'guard-rspec', '~> 4.0'
  s.add_development_dependency 'growl', '~> 1.0'
end
