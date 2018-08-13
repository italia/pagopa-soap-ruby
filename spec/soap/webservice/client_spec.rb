# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Webservice::Client do
  context "with not initialized sub class" do
    subject(:client) do
      described_class.new
    end

    it "has undefined method namespace" do
      expect do
        described_class.namespace
      end.to raise_error(NoMethodError, /undefined method/)
    end

    it "has undefined method action" do
      expect do
        described_class.action
      end.to raise_error(NoMethodError, /undefined method/)
    end
  end
end
