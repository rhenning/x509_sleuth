require "formatador"

module X509Sleuth
  class ScannerPresenter
    attr_reader :scanner

    def initialize(scanner)
      @scanner = scanner
    end

    def tableize
      scanner.clients.reject do |client|
        client.connect_failed?
      end.collect do |client|
        {
          host:       client.host,
          subject:    client.peer_certificate.subject,
          issuer:     client.peer_certificate.issuer,
          serial:     client.peer_certificate.serial,
          not_before: client.peer_certificate.not_before, 
          not_after:  client.peer_certificate.not_after
        }
      end
    end

    def to_s
      Formatador.display_compact_table(
        tableize,
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
