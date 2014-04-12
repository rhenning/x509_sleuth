require "x509_sleuth/version"

module X509Sleuth
  class << self 
    def version_string
      "X509 Sleuth version #{X509Sleuth::VERSION}"
    end
  end
end
