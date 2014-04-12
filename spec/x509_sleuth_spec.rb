require "spec_helper"

describe X509Sleuth do
  it "returns the correct version string" do
    expect(described_class.version_string).to eq("X509 Sleuth version #{X509Sleuth::VERSION}")
  end
end
