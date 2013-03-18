# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_track/version'

Gem::Specification.new do |gem|
  gem.name          = "time_track"
  gem.version       = TimeTrack::VERSION
  gem.authors       = ["Guillaume Garcera"]
  gem.email         = ["guillaume@ciblo.net"]
  gem.description   = %q{Various extraction from hamster time tracking}
  gem.summary       = %q{Various extraction from hamster time tracking}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'ruby-dbus'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'thor'
  gem.add_dependency 'chronic'
  gem.add_dependency 'pp'

end
