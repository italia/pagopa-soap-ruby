# frozen_string_literal: true

require "spec_helper"

RSpec.describe PagopaSoap do
  let(:base) do
    File.expand_path("../../resources/pagopa_base.wsdl", __dir__)
  end
  let(:notify) do
    File.expand_path("../../resources/pagopa_avvisi.wsdl", __dir__)
  end
  let(:configuration) do
    {
      namespace: "PagoPa",
      wsdl_base: base,
      wsdl_notify: notify,
      endpoint_base: nil,
      endpoint_notify: nil
    }
  end

  it "has a version number" do
    expect(PagopaSoap::VERSION).not_to be nil
  end

  it "has a default options" do
    expect(described_class.options).to eq(configuration)
  end
end
