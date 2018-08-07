# frozen_string_literal: true

require "spec_helper"

RSpec.describe PagopaSoap do
  it "has a version number" do
    expect(PagopaSoap::VERSION).not_to be nil
  end

  it "has a default options" do
    expect(described_class.options).to eq(
      namespace: "PagoPa",
      wsdl: File.expand_path("../../resources/pagopa.wsdl", __dir__)
    )
  end
end
