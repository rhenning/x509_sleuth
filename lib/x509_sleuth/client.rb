require "socket"
require "openssl"
require "timeout"

module X509Sleuth
  class Client
    attr_reader :host, :port, :timeout_secs

    def initialize(host, options = {})
      options = {
        port:           443,
        timeout_secs:   15
      }.merge(options)

      @host         = host
      @port         = options[:port]
      @timeout_secs = options[:timeout_secs]
    end

    def tcp_socket
      @tcp_socket ||= TCPSocket.new(@host, @port)
    end

    def ssl_socket
      @ssl_socket ||= OpenSSL::SSL::SSLSocket.new(tcp_socket)
    end

    def connect
      Timeout::timeout(@timeout_secs) do
        ssl_socket.connect
      end
    end

    def peer_certificate
      @peer_certficate ||= ssl_socket.peer_cert
    end
  end
end
