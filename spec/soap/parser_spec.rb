require "spec_helper"

RSpec.describe Soap::Parser do
  context 'with: generic.wsdl' do
    let(:xml) { fixture(:generic).read }

    subject do
      Soap::Parse.new(xml)
    end

    it "soap_actions class is array" do
      expect(subject.soap_actions.class).to eq(Array)
    end

    it "soap_actions match list array" do
      expect(subject.soap_actions).to match_array(["nodoChiediStatoRPT", "nodoInviaRPT"])
    end

    it "namespaces class is Hash" do
      expect(subject.namespaces.class).to eq(Hash)
    end

    it "custom namespace present into WSDL" do
      expect(subject.namespaces).to include({"ppt" => "http://ws.pagamenti.telematici.gov/"})
      expect(subject.namespaces).to include({"ppthead" => "http://ws.pagamenti.telematici.gov/ppthead"})
    end
  end
end
