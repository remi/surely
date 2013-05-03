# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "surely/version"

Gem::Specification.new do |s|
  s.name        = "surely"
  s.version     = Surely::VERSION
  s.authors     = ["Rémi Prévost"]
  s.email       = ["remi@exomel.com"]
  s.homepage    = "http://github.com/remiprev/surely"
  s.license     = "MIT"
  s.summary     = "Surely watches your screenshots directory and upload new files to your imgur account."
  s.description = "Surely watches your screenshots directory and upload new files to your imgur account."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "faraday", '~> 0.8'
  s.add_runtime_dependency "listen", '~> 1.0'
  s.add_runtime_dependency "multi_json", '~> 1.7'
  s.add_runtime_dependency "yajl-ruby", '~> 1.1'
  s.add_runtime_dependency "raad", '~> 0.5'

  s.add_development_dependency "rake", '~> 10.0'
end
