require "formatador"

module X509Sleuth
  class ScannerPresenter
    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    def filter
      @scanner.clients.reject do |client|
        client.connect_failed?
      end
    end

    def tableize(clients)
      clients.collect do |client|
        if client.peer_certificate
          {
            host:       client.host,
            subject:    client.peer_certificate.subject,
            issuer:     client.peer_certificate.issuer,
            serial:     client.peer_certificate.serial,
            not_before: client.peer_certificate.not_before, 
            not_after:  client.peer_certificate.not_after
          }
        else
          {
            host:       client.host,
            subject:    "",
            issuer:     "",
            serial:     "",
            not_before: "", 
            not_after:  ""
          }
        end
      end
    end

    def to_s
      Formatador.display_compact_table(
        tableize(filter),
        [
          :host,
          :subject,
          :serial,
          :not_before,
          :not_after
        ]
      )
    end
  end
end
