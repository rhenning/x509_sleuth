require_relative "../spec_helper"

describe X509Sleuth::Client do
  let(:host) { "somehost" }
  let(:tcp_socket_double) { double(TCPSocket) }
  let(:ssl_socket_double) { double(OpenSSL::SSL::SSLSocket) }
  let(:client) { described_class.new(host) }

  before do
    allow(TCPSocket).to receive(:new).and_return(tcp_socket_double)
    allow(OpenSSL::SSL::SSLSocket).to receive(:new).and_return(ssl_socket_double)
  end

  context "when initialized" do
    context "with no options" do
      subject { described_class.new(host) }

      its(:host) { should eq(host) }
      its(:port) { should eq(443) }
      its(:timeout_secs) { should eq(15) }
    end

    context "with options" do
      subject do
        described_class.new(
          host,
          port:         40443,
          timeout_secs: 3
        )
      end

      its(:host) { should eq(host) }
      its(:port) { should eq(40443) }
      its(:timeout_secs) { should eq(3) }
    end
  end

  describe "#tcp_socket" do
    it "creates a TCP socket with the correct host and port" do
      expect(TCPSocket).to receive(:new).with(host, 443).and_return(tcp_socket_double)
      
      client.tcp_socket
    end
  end

  describe "#ssl_socket" do
    it "creates an SSL socket from the tcp_socket" do
      expect(OpenSSL::SSL::SSLSocket).to receive(:new).with(tcp_socket_double).and_return(ssl_socket_double)
      
      client.ssl_socket
    end
  end

  describe "#connect" do
    it "connects to the remote server using OpenSSL" do
      expect(ssl_socket_double).to receive(:connect).once
      
      client.connect
    end
  end

  describe "#peer_certificate" do
    it "retrieves the remote host's X.509 certificate" do
      expect(ssl_socket_double).to receive(:peer_cert).once
    
      client.peer_certificate
    end
  end
end
