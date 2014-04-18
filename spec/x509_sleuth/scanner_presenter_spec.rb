require_relative "../spec_helper"

describe X509Sleuth::ScannerPresenter do
  let(:x509_cert_double) do
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
      serial:     12227668858515977,
      not_before: Time.utc(2014, 4,  10, 20, 19, 9),
      not_after:  Time.utc(2014, 10, 3,  23, 22, 57)
    ) 
  end

  let(:ok_client_double) do
    double(
      X509Sleuth::Client,
      host:             "ok.client.tld",
      connect_failed?:  false,
      peer_certificate: x509_cert_double
    )
  end

  let(:failed_client_double) do
    double(
      X509Sleuth::Client,
      host:             "failed.client.tld",
      connect_failed?:  true,
      connect_error:    TimeoutError.new
    )
  end

  let(:scanner_double) do
    double(
      X509Sleuth::Scanner,
      clients: [ok_client_double, failed_client_double]
    )
  end

  let(:scanner_presenter) { described_class.new(scanner_double) }

  context "instances" do
    subject { scanner_presenter }

    it { should respond_to(:scanner).with(0).arguments }
    it { should respond_to(:tableize).with(0).arguments }
    it { should respond_to(:to_s).with(0).arguments }
  end

  describe "#tableize" do
    let(:ok_client_tableized_result) do
      {
        host:       ok_client_double.host,
        subject:    x509_cert_double.subject,
        issuer:     x509_cert_double.issuer,
        serial:     x509_cert_double.serial,
        not_before: x509_cert_double.not_before,
        not_after:  x509_cert_double.not_after
      }
    end

    let(:failed_client_tableized_result) do
      {
        host:             "failed.client.tld",
        connect_failed?:  true,
        connect_error:    TimeoutError.new
      }
    end

    it "returns the expected Formatador table" do
      expect(scanner_presenter.tableize).to include(ok_client_tableized_result)
    end

    it "excludes clients with failed connections" do
      expect(scanner_presenter.tableize).to_not include(failed_client_tableized_result)
    end
  end
end
