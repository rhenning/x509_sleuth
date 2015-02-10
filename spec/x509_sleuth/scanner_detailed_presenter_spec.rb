require_relative "../spec_helper"

describe X509Sleuth::ScannerDetailedPresenter do
  let(:simple_x509_cert_double) do
    double(
      OpenSSL::X509::Certificate,
      subject:    "/OU=Domain Control Validated"\
                  "/CN=*.mydomain.tld",
      issuer:     "/C=US"\
                  "/ST=Arizona"\
                  "/L=Scottsdale"\
                  "/O=GoDaddy.com, Inc."\
                  "/OU=http://certs.godaddy.com/repository/"\
                  "/CN=Go Daddy Secure Certificate Authority - G2",
      extensions: [],
      serial:     12227668858515977,
      not_before: Time.utc(2014, 4,  10, 20, 19, 9),
      not_after:  Time.utc(2014, 10, 3,  23, 22, 57)
    ) 
  end

  let(:san_x509_cert_double) do
    double(
      OpenSSL::X509::Certificate,
      subject:    "/C=US"\
                  "/postalCode=19103"\
                  "/ST=PA"\
                  "/L=Philadelphia"\
                  "/street=123 Fake Street"\
                  "/O=Fake Corp"\
                  "/OU=Fake Department"\
                  "/CN=fake.example.com",
      issuer:     "/C=GB"\
                  "/ST=Greater Manchester"\
                  "/L=Salford"\
                  "/O=COMODO CA Limited"\
                  "/CN=COMODO High-Assurance Secure Server CA",
      extensions: [
        OpenSSL::X509::Extension.new("authorityKeyIdentifier", "keyid:3F:D5:B5:D0:D6:44:79:50:4A:17:A3:9B:8C:4A:DC:B8:B0:23:64:6F"),
        OpenSSL::X509::Extension.new("subjectKeyIdentifier", "A3:F1:44:92:8F:53:2D:69:66:56:0A:69:20:8B:F4:6B:5F:18:88:1D"),
        OpenSSL::X509::Extension.new("keyUsage", "Digital Signature, Key Encipherment", true),
        OpenSSL::X509::Extension.new("basicConstraints", "CA:FALSE", true),
        OpenSSL::X509::Extension.new("extendedKeyUsage", "TLS Web Server Authentication, TLS Web Client Authentication"),
        OpenSSL::X509::Extension.new("certificatePolicies", "Policy: 1.3.6.1.4.1.6449.1.2.1.3.4\nCPS: https://secure.comodo.com/CPS\nPolicy: 2.23.140.1.2.2"),
        OpenSSL::X509::Extension.new("crlDistributionPoints", "URI:http://crl.comodoca.com/COMODOHigh-AssuranceSecureServerCA.crl"),
        OpenSSL::X509::Extension.new("authorityInfoAccess", "CA Issuers - URI:http://crt.comodoca.com/COMODOHigh-AssuranceSecureServerCA.crt\nOCSP - URI:http://ocsp.comodoca.com"),
        OpenSSL::X509::Extension.new("subjectAltName", "DNS:foo.example.com, DNS:bar.example.com")

      ],
      serial:     12227668858515977,
      not_before: Time.utc(2014, 4,  10, 20, 19, 9),
      not_after:  Time.utc(2014, 10, 3,  23, 22, 57)
    ) 
  end

  let(:simple_client_double) do
    double(
      X509Sleuth::Client,
      host:             "www.mydomain.tld",
      connect_failed?:  false,
      peer_certificate: simple_x509_cert_double
    )
  end

  let(:san_client_double) do
    double(
      X509Sleuth::Client,
      host:             "fake.example.com",
      connect_failed?:  false,
      peer_certificate: san_x509_cert_double
    )
  end

  let(:scanner_double) do
    double(
      X509Sleuth::Scanner,
      clients: [simple_client_double, san_client_double]
    )
  end

  let(:scanner_presenter) { described_class.new(scanner_double) }


  describe "#tableize" do
    let(:ok_client_tableized_results) do
      [
        {
          host:       simple_client_double.host,
          subject:    simple_x509_cert_double.subject,
          common_name: "*.mydomain.tld",
          alt_names:  "",
          issuer:     simple_x509_cert_double.issuer,
          serial:     simple_x509_cert_double.serial,
          not_before: simple_x509_cert_double.not_before,
          not_after:  simple_x509_cert_double.not_after
        },
        {
          host:       san_client_double.host,
          subject:    san_x509_cert_double.subject,
          common_name: "fake.example.com",
          alt_names:  "foo.example.com,bar.example.com",
          issuer:     san_x509_cert_double.issuer,
          serial:     san_x509_cert_double.serial,
          not_before: san_x509_cert_double.not_before,
          not_after:  san_x509_cert_double.not_after
        }
      ]
    end

    it "returns the expected Formatador table" do
      ok_client_tableized_results.each do |cert_details|
        expect(scanner_presenter.tableize(scanner_double.clients)).to include(cert_details)
      end
    end
  end
end
