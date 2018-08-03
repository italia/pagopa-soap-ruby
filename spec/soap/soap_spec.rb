require "spec_helper"

RSpec.describe Soap do
  describe "to_snakecase" do
    it "lowercases one word CamelCase" do
      expect(Soap.to_snakecase("Nodo")).to eq("nodo")
    end

    it "makes one underscore snakecase two word CamelCase" do
      expect(Soap.to_snakecase("NodoChiedi")).to eq("nodo_chiedi")
    end

    it "makes underscore and lowercase" do
      expect(Soap.to_snakecase("NodoChiediRPT")).to eq("nodo_chiedi_rpt")
    end
  end

  describe "to_camelcase" do
    it "makes snakecase to camelcase" do
      expect(Soap.to_camelcase("NodoChiediRPT")).to eq("NodoChiediRpt")
    end
  end
end
