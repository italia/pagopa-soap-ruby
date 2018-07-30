# frozen_string_literal: true

require "nokogiri"
require "soap/string"

# Parser
require "soap/parser"
require "soap/parser/type"
require "soap/parser/port_type"
require "soap/parser/binding"
require "soap/parser/message"

# WebService
require "soap/webservice/request"
require "soap/webservice/response"
require "soap/webservice/client"

module Soap
  class << self
    def to_snakecase(str)
      Soap::String.snakecase(str)
    end

    def to_camelcase(str)
      Soap::String.camelcase(
        Soap.to_snakecase(str)
      )
    end
  end
end

class Soap::Base
  attr_reader :wsdl
  attr_reader :namespace

  def initialize(wsdl:, namespace:)
    @wsdl = wsdl
    @namespace = namespace
  end

  def build
    module_name = Object.const_set(namespace, Module.new)
    parser.soap_actions.each do |action|
      build_klass(module_name, action, parser.soap_action(action))
    end
    true
  end

  def build_klass(module_const, name, action)
    klass = Class.new(Soap::Webservice::Client) do
      
    end

    request_klass = build_custom_klass(module_const, "Request", name, action[:input])
    response_klass = build_custom_klass(module_const, "Response", name, action[:output])

    module_const.const_set(Soap.to_camelcase("#{name}Client"), klass)
  end

  def build_custom_klass(module_const, type_klass, name_klass, action_klass)
    klass = Class.new(Object.const_get("Soap::Webservice::#{type_klass}")) do
      
    end
    module_const.const_set(Soap.to_camelcase("#{name_klass}#{type_klass}"), klass)
  end

  private

  def parser
    @parser ||= Soap::Parse.new(Nokogiri::XML(File.read(wsdl)))
  end
end
