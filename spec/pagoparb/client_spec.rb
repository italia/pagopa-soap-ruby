# frozen_string_literal: true

require "spec_helper"

describe Pagoparb::Client do
  let(:subject) { Pagoparb::Client.new() }

  describe "#operations" do
    it "should return list of operations from the wsdl" do
      expect(subject.operations).to be_an(Array)
    end
  end
end
