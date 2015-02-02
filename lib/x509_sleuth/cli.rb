require 'thor'

module X509Sleuth
  class Cli < Thor
      
    def self.exit_on_failure?
      true
    end

    class_option :target, :type => :array, :required => true
      
    desc "scan", "Scan the specified target(s) for certificate details"
    def scan
      options[:target].each do |target|
        my_client.add_target(target)
      end
      my_client.run
      output = X509Sleuth::ScannerPresenter.new(my_client)
      puts output.to_s
    end

    no_commands do
      def my_client
        @client ||= X509Sleuth::Scanner.new
        @client
      end  
    end
  end
end