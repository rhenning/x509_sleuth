require "formatador"
require "x509_sleuth/scanner_presenter"

module X509Sleuth
  class ScannerDetailedPresenter < ScannerPresenter
    def tableize(clients)
      clients.collect do |client|
        if client.peer_certificate
          {
            host: client.host,
            subject: client.peer_certificate.subject,
            common_name: parse_cn(client.peer_certificate),
            alt_names: parse_san(client.peer_certificate).join(","),
            issuer: client.peer_certificate.issuer,
            serial: client.peer_certificate.serial,
            not_before: client.peer_certificate.not_before, 
            not_after: client.peer_certificate.not_after
          }
        else
          {
            host: client.host,
            subject: "",
            common_name: "",
            alt_names: [],
            issuer: "",
            serial: "",
            not_before: "", 
            not_after: ""
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
          :common_name,
          :alt_names,
          :issuer,
          :serial,
          :not_before,
          :not_after
        ]
      )
    end

    def parse_cn(cert)
      subject_parts = cert.subject.to_s.split("/").collect{ |p| p.split("=") }
      common_name = ""
      subject_parts.each do |part|
        if part[0] && part[0] == "CN"
          common_name = part[1]
          break
        end
      end
      common_name
    end

    def parse_san(cert)
      subject_alt_names = []
      cert.extensions.each do |extension|
        if extension.oid == "subjectAltName"
          subject_alt_names = extension.value.split(/[:,]|\s/).reject{ |part| part.nil? || part.empty? || part == "DNS" }
        end
      end
      subject_alt_names
    end
  end
end