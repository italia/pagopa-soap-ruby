# frozen_string_literal: true

module Pagoparb
  class Client
    attr_reader :client
    attr_reader :headers

    def initialize(options = {})
      # if required_option?
      #   raise_initialization_error!
      # end

      @wsdl = options[:wsdl] || File.expand_path(
        "../../resources/nodo_per_pa.wsdl",
        __dir__
      )
      @namespace = options[:namespace] || Pagoparb.config.namespace
      @endpoint = options[:endpoint] || Pagoparb.config.endpoint
      @ssl_version = options[:ssl_version] || :TLSv1_2
      @logger = options[:logger] || Pagoparb.config.logger
      @response_tags = options[:tag_style] || Pagoparb.config.tag_style

      @client = Savon.client(
        {
          wsdl: @wsdl,
          namespace: @namespace,
          endpoint: @endpoint,
          soap_header: @headers,
          convert_request_keys_to: :none,
          convert_response_tags_to: @response_tags,
          pretty_print_xml: true,
          logger: @logger,
          ssl_version: @ssl_version,
          follow_redirects: true,
          headers: {
            "User-Agent" => "Ruby Wrapper pagoPA (#{Pagoparb::VERSION})",
            "Cache-Control" => "no-cache",
            "Accept-Encoding" => "gzip, deflate"
          }
        }
      )
    end

    # Public: Get the names of all wsdl operations.
    # List all available operations from the partner.wsdl
    def operations
      @client.operations
    end

    def wsdl
      @client.wsdl
    end

    def method_missing(method, *args)
      Response.new(@client, method.to_sym, args)
    end

    private

    def raise_initialization_error!
      raise InitializationError,
        "Expected either a WSDL document or the SOAP endpoint" \
        "and target namespace options."
    end
  end
end
