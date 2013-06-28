$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "menu_structure/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "menu_structure"
  s.version     = MenuStructure::VERSION
  s.authors     = ["Lars Schirrmeister"]
  s.email       = ["l.schirrmeister@me.com"]
  s.homepage    = "http://insciens.net/"
  s.summary     = "Handling menu entries in a rails app"
  s.description = "Simple store for entries in a typical treelike menu."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2.13"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "generator_spec"
end
