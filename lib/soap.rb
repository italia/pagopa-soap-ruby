# frozen_string_literal: true

require "nokogiri"
require "gyoku"
require "nori"
require "soap/string"

# Parser
require "soap/parser"
require "soap/parser/types"
require "soap/parser/port_type"
require "soap/parser/binding"
require "soap/parser/message"
require "soap/parser/service"

# WebService
require "soap/webservice/request"
require "soap/webservice/response"
require "soap/webservice/client"
require "soap/webservice/error"
require "soap/webservice/fault_error"

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

    def to_wsdl_camelcase(str)
      Soap::String.wsdl_camelcase(
        Soap.to_snakecase(str)
      )
    end
  end
end

class Soap::Base
  SUB_CLASSES = %i[request client response].freeze
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
    service_name = parser.service[:base_endpoint]
    k_mod = mod.const_set(Soap.to_camelcase(name), Module.new)
    build_custom_klass(k_mod, "Request", action[:input])
    build_custom_klass(k_mod, "Response", action[:output])

    klass = Class.new(Soap::Webservice::Client) do
      define_singleton_method :namespace do
        service_name
      end

      define_singleton_method :action do
        action[:input][:port_type][:name]
      end

      define_method :response do
        @response ||= k_mod.const_get("Response")
      end

      # rubocop:disable all
      private :response
      # rubocop:enable all
    end
    k_mod.const_set("Client", klass)
  end

  def build_custom_klass(mod, type_klass, action_klass)
    klass = Class.new(Object.const_get("Soap::Webservice::#{type_klass}")) do
      define_singleton_method :body_attributes do
        action_klass[:types][:body]
      end

      define_singleton_method :header_attributes do
        action_klass[:types][:header]
      end
    end

    mod.const_set(type_klass.to_s, klass)
  end

  SUB_CLASSES.each do |sub_class|
    define_method(sub_class) do
      name = Soap.to_camelcase(sub_class.to_s)
      parser.soap_actions.map do |action|
        "#{namespace}::#{Soap.to_camelcase(action)}::#{name}"
      end
    end
  end

  private

  def parser
    @parser ||= Soap::Parse.new(File.read(wsdl))
  end
end
