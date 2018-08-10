lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'x509_sleuth/version'


Gem::Specification.new do |s|
  s.name        = "x509_sleuth"
  s.version     = X509Sleuth::VERSION
  s.date        = Date.today.to_s
  s.summary     = "A tool to remotely scan for and investigate X.509 certificates used in SSL/TLS"
  s.author      = "Richard Henning"
  s.email       = "rich@tonaleclipse.com"
  s.license     = "MIT"
  s.homepage    = "https://github.com/rhenning/x509_sleuth"
  s.files       = Dir.glob("lib/**/*.rb")
  s.test_files  = Dir.glob("spec/**/*.rb")
  s.executables = ["x509_sleuth"]
  
  s.add_runtime_dependency "formatador"
  s.add_runtime_dependency "netaddr", "~> 1.5"
  s.add_runtime_dependency "parallel"
  s.add_runtime_dependency "thor"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-collection_matchers", "~> 1.1.2"
  s.add_development_dependency "travis-lint"
end
