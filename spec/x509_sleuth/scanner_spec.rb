require_relative "../spec_helper"

describe X509Sleuth::Scanner do
  let(:scanner) { described_class.new }
  let(:scanner_with_overrides) { described_class.new(concurrency: 127) }
  let(:cidr_target_string) { "127.0.0.1/30" }
  let(:host_target_string) { "bigserver.domain.local" }
  let(:scanner_targets) do
    [
      X509Sleuth::Scanner::Target.new(cidr_target_string),
      X509Sleuth::Scanner::Target.new(host_target_string)
    ]
  end

  context "instances" do
    subject { scanner }

    it { should respond_to(:add_target).with(1).arguments }
    it { should_not respond_to(:add_target).with(0).arguments }
    it { should respond_to(:targets).with(0).arguments }
    it { should respond_to(:clients).with(0).arguments }
    it { should respond_to(:concurrency) }
    it { should respond_to(:clients).with(0).arguments }
    it { should respond_to(:run).with(0).arguments }

    context "with option overrides" do
      subject { scanner_with_overrides }

      its(:concurrency) { should eq(127) }
    end
  end

  describe "#add_target" do
    it "adds the target to the targets list" do
      scanner.add_target(cidr_target_string)

      expect(scanner.targets).to have(1).item
      expect(scanner.targets).to be_all { |item| item.is_a?(X509Sleuth::Scanner::Target) }
    end

    it "appends to an existing targets list" do
      scanner.add_target(cidr_target_string)
      scanner.add_target(host_target_string)

      expect(scanner.targets).to have(2).items
    end
  end

  describe "#clients" do
    before do
      allow(scanner).to receive(:targets).and_return(scanner_targets)
    end

    it "contains a collection of clients from the loaded targets" do
      scanner.add_target(cidr_target_string)
      scanner.add_target(host_target_string)

      expect(scanner.clients).to have(3).items
      expect(scanner.clients).to be_all { |item| item.is_a?(X509Sleuth::Client) }
    end
  end

  describe "#run" do
    let(:client_double) { double(X509Sleuth::Client) }
    let(:scanner_clients) { [client_double, client_double] }

    before do
      allow(scanner).to receive(:clients).and_return(scanner_clients)
    end

    it "connects to all the hosts" do
      expect(client_double).to receive(:connect).exactly(2).times
      scanner.run
    end
  end
end
