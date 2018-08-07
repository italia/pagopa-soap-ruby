# frozen_string_literal: true

require "spec_helper"

RSpec.describe Soap::Parser::Types do
  context "with generic.wsdl" do
    subject(:types) do
      parser = Soap::Parse.new(xml)
      types = described_class.new(
        parser.namespaces,
        parser.section("types")
      )
      types.parse
      types
    end

    let(:xml) { fixture(:generic).read }
    let(:children) { types.node.first.element_children }
    let(:schema) { children.first }

    it "has at least one node children" do
      expect(types.node.first.element_children.count).to be >= 1
    end

    it "node children are schema" do
      expect(children.map(&:name)).to include("schema")
    end

    it "each schema has a targetNamespace" do
      expect(schema["targetNamespace"]).to eq(
        "http://ws.pagamenti.telematici.gov/ppthead"
      )
    end
  end
end
