# frozen_string_literal: true

module PagopaSoap
  class << self
    # List of configurable keys for {Pagoparb::Client}
    # @return [Array] of option keys
    def keys
      @keys ||= [
        :namespace,
        :wsdl
      ]
    end

    def config
      @config ||= Configurable.new
    end

    # Set configuration options using a block
    def configure
      yield(config)
    end
  end

  class Configurable
    attr_accessor :namespace
    attr_accessor :wsdl

    def initialize
      @namespace ||= "Pagopa::Soap"
      @wsdl ||= File.expand_path("../../resources/pagopa.wsdl", __dir__)
    end
  end
end
