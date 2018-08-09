# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser::Message do
  context "with generic.wsdl" do
    subject(:message) do
      parser = Soap::Parse.new(xml)
      message = described_class.new(
        parser.namespaces,
        parser.section("message")
      )
      message.parse
      message
    end

    let(:xml) { fixture(:generic).read }

    it "has hash with list of soap operations" do
      expect(message.hash).to include("nodoChiediStatoRPT")
    end

    it "each message include parts in which it is divided" do
      expect(message.hash["nodoChiediStatoRPT"]).to include(:part)
    end

    it "header parts has the name of the element in the types schema WSDL" do
      expect(
        message.hash["nodoInviaRPT"][:part]["header"]
      ).to eq("ppthead:intestazionePPT")
    end

    it "body parts has the name of the element in the types schema WSDL" do
      expect(
        message.hash["nodoInviaRPT"][:part]["bodyrichiesta"]
      ).to eq("ppt:nodoInviaRPT")
    end
  end

  context "with binding_no_name.wsdl" do
    subject(:message) do
      parser = Soap::Parse.new(xml)
      message = described_class.new(
        parser.namespaces,
        parser.section("message")
      )
      message.parse
      message
    end

    let(:xml) { fixture(:binding_no_name).read }

    it "has hash with list of soap operations" do
      expect(message.hash).to include("nodoInviaAvvisoDigitale")
    end

    it "each message include parts in which it is divided" do
      expect(message.hash["nodoInviaAvvisoDigitale"]).to include(:part)
    end

    it "header parts has the name of the element in the types schema WSDL" do
      expect(
        message.hash["nodoInviaAvvisoDigitale"][:part]["header"]
      ).to eq("sachead:intestazionePPT")
    end

    it "body parts has the name of the element in the types schema WSDL" do
      expect(
        message.hash["nodoInviaAvvisoDigitale"][:part]["bodyrichiesta"]
      ).to eq("sac:nodoInviaAvvisoDigitale")
    end
  end
end
