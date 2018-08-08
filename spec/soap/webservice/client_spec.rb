# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Webservice::Client do
  context "with not initialized sub class" do
    subject(:client) do
      described_class.new
    end

    it "has nil namespace" do
      expect(described_class.namespace).to be_nil
    end

    it "has nil action" do
      expect(described_class.action).to be_nil
    end
  end
end
