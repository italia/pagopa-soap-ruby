require "spec_helper"

RSpec.describe Soap::Parser::Binding do
  context 'with: generic.wsdl' do
    let(:xml) { fixture(:generic).read }

    subject do
      parser = Soap::Parse.new(xml)
      binding = Soap::Parser::Binding.new(parser.namespaces, parser.section("binding"))
      binding.parse
      binding
    end

    it "has hash with name" do
      expect(subject.hash).to include(:name)
    end

    it "has a list of operations" do
      expect(subject.hash).to include(:operations)
      expect(subject.hash[:operations].class).to eq(Hash)
      expect(subject.hash[:operations]).to include("nodoInviaRPT")
    end

    it "each operation has input and output" do
      expect(subject.hash[:operations]["nodoChiediStatoRPT"]).to include(:input)
      expect(subject.hash[:operations]["nodoChiediStatoRPT"]).to include(:output)
    end

    it "if the WSDL input operation node has one part, this is insert directly" do
      expect(subject.hash[:operations]["nodoChiediStatoRPT"][:input]).to include("body")
      expect(subject.hash[:operations]["nodoChiediStatoRPT"][:input]["body"]).to include(name: "nodoChiediStatoRPT")
    end

    it "if the WSDL input operation node has header and body part, these are separate and include part and message directive" do
      expect(subject.hash[:operations]["nodoInviaRPT"][:input]).to include("body")
      expect(subject.hash[:operations]["nodoInviaRPT"][:input]).to include("header")
      expect(subject.hash[:operations]["nodoInviaRPT"][:input]["header"]).to include(:part)
      expect(subject.hash[:operations]["nodoInviaRPT"][:input]["header"]).to include(:message)
      expect(subject.hash[:operations]["nodoInviaRPT"][:input]["body"]).to include(:parts)
    end
  end
end
