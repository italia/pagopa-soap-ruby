# frozen_string_literal: true
require 'nokogiri'

module Pagoparb
  class Dsl
    attr_reader :wsdl

    def initialize(wsdl)
      @wsdl = wsdl
    end

    def build
      @parser.soap_actions.each do |operation|
        Pagoparb::Base.new(@parser)
      end
    end

    private

    def parser
      @parser ||= Pagoparb::Parser::Xml.new(Nokogiri::XML(File.read(wsdl))
    end
  end
end
