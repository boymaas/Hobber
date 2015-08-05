# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hobber/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Boy Maas"]
  gem.email         = ["boy.maas@gmail.com"]
  gem.description   = %q{Minimal implementation ..}
  gem.summary       = %q{Minimal implementation ..}
  gem.homepage      = "http://www.github.com/boymaas/Hobber"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hobber"
  gem.require_paths = ["lib"]
  gem.version       = Hobber::VERSION
  
  gem.add_dependency 'tilt'
  gem.add_dependency 'thor'

  gem.add_dependency "activesupport"
  gem.add_dependency "sprockets"
end
