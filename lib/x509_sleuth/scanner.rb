require "x509_sleuth/scanner/target"
require "parallel"

module X509Sleuth
  class Scanner
    attr_accessor :concurrency
    attr_reader   :clients, :targets

    def initialize(options = {})
      options = {
        concurrency: 5
      }.merge(options)

      @concurrency  = options[:concurrency]
      @targets      = []
    end

    def add_target(target_string)
      @targets << X509Sleuth::Scanner::Target.new(target_string)
    end

    def clients
      @clients ||=
        targets.collect do |target|
          target.hosts.collect do |host|
            X509Sleuth::Client.new(host)
          end
        end.flatten
    end

    def run
      Parallel.each(clients, in_threads: concurrency) do |client|
        client.connect
      end
    end
  end
end
