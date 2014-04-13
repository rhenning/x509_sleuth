require "x509_sleuth/version"
require "x509_sleuth/client"

module X509Sleuth
  class << self 
    def version_string
      "X509 Sleuth version #{VERSION}"
    end
  end
end
