require "x509_sleuth/client"
require "x509_sleuth/scanner"
require "x509_sleuth/scanner_detailed_presenter"
require "x509_sleuth/scanner_presenter"
require "x509_sleuth/version"

module X509Sleuth
  class << self 
    def version_string
      "X509 Sleuth version #{VERSION}"
    end
  end
end
