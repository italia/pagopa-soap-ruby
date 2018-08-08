# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Webservice::Response do
  context "with not initialized sub class" do
    subject(:response) do
      described_class.new
    end

    it "has a body_attributes empty" do
      expect(described_class.body_attributes).to eq({})
    end
  end
end
