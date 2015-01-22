require "rspec"
require "x509_sleuth"
require "x509_sleuth/scanner_presenter"

require "rspec/collection_matchers"

RSpec.configure do |config|
  config.color = true
  config.formatter = "documentation"
end
