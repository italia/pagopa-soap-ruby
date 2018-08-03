# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser::PortType do
  context 'with: generic.wsdl' do
    let(:xml) { fixture(:generic).read }

    subject do
      parser = Soap::Parse.new(xml)
      port_type = Soap::Parser::PortType.new(parser.namespaces, parser.section("port_type"))
      port_type.parse
      port_type
    end

    it "has hash with list of soap operations" do
      expect(subject.hash.class).to eq(Hash)
      expect(subject.hash).to include("nodoChiediStatoRPT")
    end

    it "the keys of hash, are the soap actions" do
      expect(subject.hash.keys).to include("nodoChiediStatoRPT")
      expect(subject.hash.keys).to include("nodoInviaRPT")
      expect(subject.hash.keys).not_to include("nodoChiediCopiaRT")
    end

    it "each operation present input and output hash" do
      expect(subject.hash["nodoInviaRPT"]).to include(:input)
      expect(subject.hash["nodoInviaRPT"]).to include(:output)
      expect(subject.hash["nodoInviaRPT"][:input]).to include(:action)
      expect(subject.hash["nodoInviaRPT"][:input]).to include(:message)
    end
  end
end
