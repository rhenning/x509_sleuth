Gem::Specification.new do |s|
  s.name        = "x509_sleuth"
  s.version     = "0.0.1"
  s.date        = "2014-04-11"
  s.summary     = "A tool to remotely scan for and investigate X.509 certificates used in SSL/TLS"
  s.author      = "Richard Henning"
  s.email       = "rich@tonaleclipse.com"
  s.license     = "MIT"
  s.homepage    = "https://github.com/rhenning/x509_sleuth"
  s.files       = Dir.glob("lib/**/*.rb")
  s.test_files  = Dir.glob("spec/**/*.rb")
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
