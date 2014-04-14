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
    subject { described_class.new(host) }

    it { should respond_to(:host) }
    it { should respond_to(:port) }
    it { should respond_to(:timeout_secs) }
    it { should respond_to(:connect) }
    it { should respond_to(:connect_failed?) }
    it { should respond_to(:connect_error) }
    it { should respond_to(:peer_certificate) }
    #it { should respond_to(:peer_certificate_subject) }
    #it { should respond_to(:peer_certificate_issuer) }
    #it { should respond_to(:peer_certificate_serial) }
    #it { should respond_to(:peer_certificate_activation_time) }
    #it { should respond_to(:peer_certificate_expiration_time) }

    context "with no options" do
      its(:host) { should eq(host) }
      its(:port) { should eq(443) }
      its(:timeout_secs) { should eq(15) }
    end

    context "with options" do
      subject { described_class.new(host, port: 40443, timeout_secs: 3) }

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

    context "gracefully handles some exceptions" do
      [
        SocketError,
        OpenSSL::SSL::SSLError,
        Timeout::Error,
        Errno::EINTR,
        Errno::ENETUNREACH,
        Errno::ENETDOWN,
        Errno::ENETRESET,
        Errno::ECONNABORTED,
        Errno::ECONNRESET,
        Errno::ETIMEDOUT,
        Errno::ECONNREFUSED,
        Errno::EHOSTDOWN,
        Errno::EHOSTUNREACH
      ].each do |e|
        it "handles #{e}" do
          allow(ssl_socket_double).to receive(:connect).and_raise(e)

          expect { client.connect }.to_not raise_error
        end
      end
    end
  end

  describe "#peer_certificate" do
    it "retrieves the remote host's X.509 certificate" do
      expect(ssl_socket_double).to receive(:peer_cert).once
    
      client.peer_certificate
    end
  end

  context "when a connection error occurs" do
    before do
      allow(ssl_socket_double).to receive(:connect).and_raise(SocketError)
    end

    describe "#connect_error" do
      it "returns the exception" do
        client.connect
        expect(client.connect_error).to be_instance_of(SocketError)
      end
    end

    describe "#connect_failed?" do
      it "returns true" do
        client.connect
        expect(client.connect_failed?).to eq(true)
      end
    end
  end

  context "when a successful connection occurs" do
    before do
      allow(ssl_socket_double).to receive(:connect)
    end

    describe "#connect_error" do
      it "returns nil" do
        client.connect
        expect(client.connect_error).to be_nil
      end
    end

    describe "#connect_failed?" do
      it "returns false" do
        client.connect
        expect(client.connect_failed?).to eq(false)
      end
    end
  end
end
