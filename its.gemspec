# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "its/version"

Gem::Specification.new do |s|
  s.name        = "its"
  s.version     = Its::VERSION
  s.authors     = ["Dmytrii Nagirniak"]
  s.email       = ["dnagir@gmail.com"]
  s.homepage    = "https://github.com/dnagir/its"
  s.summary     = %q{Testing methods with multiple arguments much easier with RSpec}
  s.description = %q{You can write `its(:currency, :us) \{ should == 'US dollars' \}`}

  s.rubyforge_project = "its"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rspec-core", "~> 2.8"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-mocks"
  s.add_development_dependency "rspec-expectations"
end
