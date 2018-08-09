# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser::PortType do
  context "with generic.wsdl" do
    subject(:port_type) do
      parser = Soap::Parse.new(xml)
      port_type = described_class.new(
        parser.namespaces,
        parser.section("port_type")
      )
      port_type.parse
      port_type
    end

    let(:xml) { fixture(:generic).read }

    it "has hash with list of soap operations" do
      expect(port_type.hash).to include("nodoChiediStatoRPT")
    end

    it "the keys of hash, are the soap actions" do
      expect(port_type.hash.keys).to match_array(
        %w[nodoChiediStatoRPT nodoInviaRPT]
      )
    end

    it "each operation present input and output hash" do
      expect(port_type.hash["nodoInviaRPT"]).to include(:input, :output)
    end
  end

  context "with binding_no_name.wsdl" do
    subject(:port_type) do
      parser = Soap::Parse.new(xml)
      port_type = described_class.new(
        parser.namespaces,
        parser.section("port_type")
      )
      port_type.parse
      port_type
    end

    let(:xml) { fixture(:binding_no_name).read }

    it "has hash with list of soap operations" do
      expect(port_type.hash).to include("nodoInviaAvvisoDigitale")
    end

    it "the keys of hash, are the soap actions" do
      expect(port_type.hash.keys).to match_array(
        %w[nodoInviaAvvisoDigitale]
      )
    end

    it "each operation present input and output hash" do
      expect(
        port_type.hash["nodoInviaAvvisoDigitale"]
      ).to include(:input, :output)
    end
  end
end
