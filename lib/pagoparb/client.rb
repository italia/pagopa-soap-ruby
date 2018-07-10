# frozen_string_literal: true

module Pagoparb;end

class Pagoparb::Client
  attr_reader :client
  attr_reader :headers

  def initialize(options = {})
    @wsdl = options[:wsdl] || File.expand_path("../../resources/nodo_per_pa.wsdl", __dir__)
    @host = options[:host] || Pagoparb::Configurable.config.host
    @endpoint = options[:endpoint] || Pagoparb::Configurable.config.endpoint
    @ssl_version = options[:ssl_version] || :TLSv1_2
    @logger = options[:logger] || Pagoparb::Configurable.config.logger
    @response_tags = options[:tag_style] || Pagoparb::Configurable.config.tag_style

    @client = Savon.client({
      wsdl: @wsdl,
      host: @host,
      endpoint: @endpoint,
      soap_header: @headers,
      convert_request_keys_to: :none,
      convert_response_tags_to: @response_tags,
      pretty_print_xml: true,
      logger: @logger,
      ssl_version: @ssl_version,
      headers: { "User-Agent" => "Wrapper API Ruby/0.0.1" }
    })
  end

  # Public: Get the names of all wsdl operations.
  # List all available operations from the partner.wsdl
  def operations
    @client.operations
  end

  def run(method, message)
    @client.call(method.to_sym, message: message)
  end
end
