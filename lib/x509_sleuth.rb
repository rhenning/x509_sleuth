require "x509_sleuth/version"
require "x509_sleuth/client"
require "x509_sleuth/scanner"

module X509Sleuth
  class << self 
    def version_string
      "X509 Sleuth version #{VERSION}"
    end
  end
end
