require "spec_helper"

RSpec.describe Soap::Parser::Message do
  context 'with: generic.wsdl' do
    let(:xml) { fixture(:generic).read }

    subject do
      parser = Soap::Parse.new(xml)
      message = Soap::Parser::Message.new(parser.namespaces, parser.section("message"))
      message.parse
      message
    end

    it "has hash with list of soap operations" do
      expect(subject.hash.class).to eq(Hash)
      expect(subject.hash).to include("nodoChiediStatoRPT")
    end

    it "each message include parts in which it is divided" do
      expect(subject.hash["nodoChiediStatoRPT"]).to include(:part)
      expect(subject.hash["nodoChiediStatoRPT"][:part]).to include("bodyrichiesta")
    end

    it "every parts has the name of the element in the types schema WSDL" do
      expect(subject.hash["nodoInviaRPT"][:part]["header"]).to eq("ppthead:intestazionePPT")
      expect(subject.hash["nodoInviaRPT"][:part]["bodyrichiesta"]).to eq("ppt:nodoInviaRPT")
    end
  end
end
