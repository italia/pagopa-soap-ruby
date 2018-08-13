# frozen_string_literal: true

module PagoPA::SOAP
  class << self
    # List of configurable keys for {Pagoparb::Client}
    # @return [Array] of option keys
    def keys
      @keys ||= %i[
        namespace wsdl_base wsdl_notify endpoint_base endpoint_notify
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
    attr_accessor :wsdl_base
    attr_accessor :wsdl_notify
    attr_accessor :endpoint_base
    attr_accessor :endpoint_notify

    def initialize
      @namespace ||= "PagoPA"
      @wsdl_base ||=
        File.expand_path("../../../resources/pagopa_base.wsdl", __dir__)
      @wsdl_notify ||=
        File.expand_path("../../../resources/pagopa_avvisi.wsdl", __dir__)
    end
  end
end
