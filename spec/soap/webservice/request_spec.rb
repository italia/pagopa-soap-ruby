# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Webservice::Request do
  context "with not initialized sub class" do
    subject(:request) do
      described_class.new
    end

    it "has an empty attributes" do
      expect(request.attributes).to eq({})
    end

    it "has an empty header_attributes" do
      expect(request.class.header_attributes).to eq({})
    end

    it "respond to XML header and body if present" do
      expect(request.to_xml).to eq(
        "<SoapHeader></SoapHeader><Message></Message>"
      )
    end
  end
end
