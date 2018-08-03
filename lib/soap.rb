# frozen_string_literal: true

require "nokogiri"
require "soap/string"

# Parser
require "soap/parser"
require "soap/parser/types"
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
    namespace_module = Object.const_set(namespace, Module.new)
    parser.soap_actions.each do |action|
      build_klass(namespace_module, action, parser.soap_action(action))
    end
    true
  end

  def build_klass(mod, name, action)
    k_mod = mod.const_set(Soap.to_camelcase(name), Module.new)
    request_klass = build_custom_klass(k_mod, "Request", name, action[:input])
    response_klass = build_custom_klass(k_mod, "Response", name, action[:output])

    klass = Class.new(Soap::Webservice::Client)
    k_mod.const_set("Client", klass)
  end

  def build_custom_klass(mod, type_klass, name_klass, action_klass)
    klass = Class.new(Object.const_get("Soap::Webservice::#{type_klass}")) do
      define_singleton_method :body_attributes do
        action_klass[:types][:body]
      end

      define_singleton_method :header_attributes do
        action_klass[:types][:header]
      end
    end

    mod.const_set("#{type_klass}", klass)
  end

  def clients
    parser.soap_actions.map do |action|
      "#{namespace}::#{Soap.to_camelcase(action)}::Client"
    end
  end

  private

  def parser
    @parser ||= Soap::Parse.new(File.read(wsdl))
  end
end
