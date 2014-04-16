require "netaddr"

module X509Sleuth
  class Scanner
    class Target
      attr_reader :target

      def initialize(target)
        @target = target
      end

      def is_a_range?
        NetAddr::CIDR.create(target).size > 1 ? true : false 
      rescue NetAddr::ValidationError
        false
      end

      def hosts
        @hosts ||=
          if is_a_range?
            cidr = NetAddr::CIDR.create(target)
            cidr.enumerate.reject do |address|
              [cidr.network, cidr.broadcast].include?(address)
            end
          else
            [target]
          end
      end
    end
  end
end
