# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "simple_nested_form/version"

Gem::Specification.new do |s|
  s.name        = "simple_nested_form"
  s.version     = SimpleNestedForm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rodrigo Navarro", "Ryan Bates"]
  s.email       = ["rnavarro1@gmail.com"]
  s.homepage    = "https://github.com/reu/simple_nested_form"
  s.summary     = "Adds support for easily creeate nested forms with simple_form" 
  s.description = "Adds support for easily creeate nested forms with simple_form"

  s.rubyforge_project = "simple_nested_form"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "simple_form", "~> 1.3.1"

  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "nokogiri", "~> 1.4.4"
  s.add_development_dependency "rails", "~> 3.0.5"
end
