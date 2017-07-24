
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "do_api_scripting/version"

Gem::Specification.new do |spec|
  spec.name          = "do_api_scripting"
  spec.version       = DoApiScripting::VERSION
  spec.authors       = ["Jeff Dickey"]
  spec.email         = ["jdickey@seven-sigma.com"]

  spec.summary       = %q{Various scripting bits for use with Ansible to manipulate DigitalOcean Droplets}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/jdickey/do_api_scripting"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-struct", '0.3.1'
  spec.add_dependency "excon", "0.57.1"
  spec.add_dependency "prolog-dry_types", '0.3.4'
  spec.add_dependency "semantic_logger", '4.1.1'
  spec.add_dependency "terminal-table", '1.8.0'
  spec.add_dependency 'thor', '0.19.4'

  spec.add_development_dependency "bundler", "1.15.3"
  spec.add_development_dependency "rake", "12.0.0"
  spec.add_development_dependency "minitest", "5.10.3"

  spec.add_development_dependency "minitest-matchers", '1.4.1'
  spec.add_development_dependency "minitest-reporters", '1.1.14'
  spec.add_development_dependency "minitest-tagz", '1.5.2'

  spec.add_development_dependency "prolog_minitest_matchers", '0.5.4'

  spec.add_development_dependency "awesome_print", '1.8.0'
  spec.add_development_dependency "benchmark-ips", '2.7.2'
  spec.add_development_dependency 'ffaker', '2.6.0'
  spec.add_development_dependency "flay", '2.9.0'
  spec.add_development_dependency "flog", '4.6.1'
  spec.add_development_dependency "pry-byebug", '3.4.2'
  spec.add_development_dependency "pry-doc", '0.10.0'
  spec.add_development_dependency "reek", '4.7.1'
  spec.add_development_dependency "rubocop", '0.49.1'
  spec.add_development_dependency "ruby-prof", '0.16.2'
  spec.add_development_dependency "simplecov", '0.14.1'
  # spec.add_development_dependency 'timerizer', '0.1.4'
end
