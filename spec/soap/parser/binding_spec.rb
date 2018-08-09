# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser::Binding do
  context "with generic.wsdl" do
    subject(:binding) do
      parser = Soap::Parse.new(xml)
      binding = described_class.new(
        parser.namespaces,
        parser.section("binding")
      )
      binding.parse
      binding
    end

    let(:xml) { fixture(:generic).read }

    it "has hash with name" do
      expect(binding.hash).to include(:name)
    end

    it "has a list of operations" do
      expect(binding.hash).to include(:operations)
    end

    it "each keys of operations is the action name" do
      expect(binding.hash[:operations]).to include("nodoInviaRPT")
    end

    it "each operation has input and output" do
      expect(
        binding.hash[:operations]["nodoChiediStatoRPT"]
      ).to include(:input, :output)
    end

    it "body operation has a name" do
      expect(
        binding.hash[:operations]["nodoChiediStatoRPT"][:input]["body"]
      ).to include(name: "nodoChiediStatoRPT")
    end

    it "header input part include part and message directive" do
      expect(
        binding.hash[:operations]["nodoInviaRPT"][:input]["header"]
      ).to include(:part, :message)
    end

    it "body input part include parts and name directive" do
      expect(
        binding.hash[:operations]["nodoInviaRPT"][:input]["body"]
      ).to include(:parts, :name)
    end
  end

  context "with binding_no_name.wsdl" do
    subject(:binding) do
      parser = Soap::Parse.new(xml)
      binding = described_class.new(
        parser.namespaces,
        parser.section("binding")
      )
      binding.parse
      binding
    end

    let(:xml) { fixture(:binding_no_name).read }

    it "has hash with name" do
      expect(binding.hash).to include(:name)
    end

    it "has a list of operations" do
      expect(binding.hash).to include(:operations)
    end

    it "each keys of operations is the action name" do
      expect(binding.hash[:operations]).to include("nodoInviaAvvisoDigitale")
    end

    it "each operation has input and output" do
      expect(
        binding.hash[:operations]["nodoInviaAvvisoDigitale"]
      ).to include(:input, :output)
    end

    it "body operation doesn't have a name" do
      expect(
        binding.hash[:operations]["nodoInviaAvvisoDigitale"][:input]["body"]
      ).to include(name: nil)
    end

    it "header input part include part and message directive" do
      expect(
        binding.hash[:operations]["nodoInviaAvvisoDigitale"][:input]["header"]
      ).to include(:part, :message)
    end

    it "body input part has a parts attribute but doesn't have a name" do
      expect(
        binding.hash[:operations]["nodoInviaAvvisoDigitale"][:input]["body"]
      ).to include(:parts, :name)
    end
  end
end
