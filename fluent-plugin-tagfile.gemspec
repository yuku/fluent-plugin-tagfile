# -*- coding:utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["taka84u9"]
  gem.email         = ["taka84u9@gmail.com"]
  gem.description   = %q{Fluent output plugin to handle output directory by source host using events tag.}
  gem.summary       = %q{Fluent output plugin to handle output directory by source host using events tag.}
  gem.homepage      = "https://github.com/taka84u9/fluent-plugin-tagfile"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "fluent-plugin-tagfile"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"
  gem.add_development_dependency "fluentd"
  gem.add_runtime_dependency "fluentd"
end
