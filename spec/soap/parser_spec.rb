# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser do
  context "with generic.wsdl" do
    subject(:parse) do
      Soap::Parse.new(xml)
    end

    let(:xml) { fixture(:generic).read }

    it "soap_actions class is array" do
      expect(parse.soap_actions.class).to eq(Array)
    end

    it "soap_actions match list array" do
      expect(parse.soap_actions).to match_array(
        %w[nodoChiediStatoRPT nodoInviaRPT]
      )
    end

    it "namespaces class is Hash" do
      expect(parse.namespaces.class).to eq(Hash)
    end

    it "custom namespace present into WSDL" do
      expect(parse.namespaces).to include(
        "ppt" => "http://ws.pagamenti.telematici.gov/",
        "ppthead" => "http://ws.pagamenti.telematici.gov/ppthead"
      )
    end
  end
end
