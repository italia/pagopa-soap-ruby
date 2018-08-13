# frozen_string_literal: true

module PagoPA; end

module PagoPA::SOAP
  class << self
    def options
      Hash[PagoPA::SOAP.keys.map { |key| [key, config.send(key)] }]
    end

    # API client based on configured options {Configurable}
    def build
      return @build if defined?(@build)
      @build = PagoPA::SOAP::WSDLLoader.new(options)
    end
  end
end
