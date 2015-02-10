# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfdi_scrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "cfdi_scrapper"
  spec.version       = CfdiScrapper::VERSION
  spec.authors       = ["Andres Amaya Diaz"]
  spec.email         = ["andres.amaya.diaz@gmail.com"]
  spec.summary       = "CFDi Scrapper for Mexico"
  spec.description   = "Generates XLS and standard text outputs from XML Invoices"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["cfdi_scrapper"] #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
