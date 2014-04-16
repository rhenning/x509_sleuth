require_relative "../../spec_helper"

describe X509Sleuth::Scanner::Target do
  let(:host_target) { described_class.new("localhost") }
  let(:ip_target) { described_class.new("127.0.0.1") }
  let(:cidr_target) { described_class.new("127.0.0.1/30") }
  let(:ip_subnet_pair_target) { described_class.new("127.0.0.1/255.255.255.248") }

  context "instances" do
    subject { host_target }

    it { should respond_to(:is_a_range?) }
    it { should respond_to(:hosts) }
    it { should respond_to(:target) }
  end

  context "when target is an IPv4 address and CIDR subnet mask" do
    describe "#is_a_range?" do
      it "returns true" do
        expect(cidr_target.is_a_range?).to be_true
      end
    end

    describe "#hosts" do
      it "returns the correct host ip addresses" do
        expect(cidr_target.hosts).to have(2).items
        expect(cidr_target.hosts).to include("127.0.0.1", "127.0.0.2")
      end

      it "omits the network and broadcast addresses" do
        expect(cidr_target.hosts).to_not include("127.0.0.0", "127.0.0.3")
      end
    end
  end

  context "when target is an IPv4 address and dotted-decimal subnet mask" do
    describe "#is_a_range?" do
      it "returns true" do
        expect(ip_subnet_pair_target.is_a_range?).to be_true
      end
    end

    describe "#hosts" do
      it "returns the correct host ip addresses" do
        expect(ip_subnet_pair_target.hosts).to have(6).items
        expect(ip_subnet_pair_target.hosts).to include(
          "127.0.0.1", "127.0.0.2", "127.0.0.3",
          "127.0.0.4", "127.0.0.5", "127.0.0.6"
        )
      end

      it "omits the network and broadcast addresses" do
        expect(ip_subnet_pair_target.hosts).to_not include("127.0.0.0", "127.0.0.7")
      end
    end
  end

  context "when target is a single IPv4 address" do
    describe "#is_a_range?" do
      it "returns false" do
        expect(ip_target.is_a_range?).to be_false
      end
    end

    describe "#hosts" do
      it "returns the lone ip address" do
        expect(ip_target.hosts).to have(1).item
        expect(ip_target.hosts).to include("127.0.0.1")
      end
    end
  end

  context "when target is assumed to be a hostname" do
    describe "#is_a_range?" do
      it "returns false" do
        expect(host_target.is_a_range?).to be_false
      end
    end

    describe "#hosts" do
      it "returns the lone hostname" do
        expect(host_target.hosts).to have(1).item
        expect(host_target.hosts).to include("localhost")
      end
    end
  end
end
