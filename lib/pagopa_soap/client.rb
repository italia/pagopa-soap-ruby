# frozen_string_literal: true

# rubocop:disable all
module Pagoparb
  class Client
    attr_reader :client
    attr_reader :headers
    attr_reader :calls

    def initialize(options = {})
      if required_option?
        raise_initialization_error!
      end

      @wsdl = options[:wsdl] || File.expand_path(
        "../../resources/nodo_per_pa.wsdl",
        __dir__
      )
      @endpoint = options[:endpoint] || Pagoparb.config.endpoint
      @logger = options[:logger] || Pagoparb.config.logger
      @log = options[:log] || false
      @response_tags = options[:tag_style] || Pagoparb.config.tag_style

      @client = Savon.client(
        {
          wsdl: @wsdl,
          endpoint: @endpoint,
          soap_header: @headers,
          convert_request_keys_to: :none,
          convert_response_tags_to: @response_tags,
          pretty_print_xml: true,
          logger: @logger,
          log: @log,
          follow_redirects: true,
          headers: {
            "User-Agent" => "Ruby Wrapper pagoPA (#{Pagoparb::VERSION})",
            "Cache-Control" => "no-cache",
            "Accept-Encoding" => "gzip, deflate"
          }
        }
      )

      @client.operations.each do |operation|
        self.class.define_method(operation) do |body|
          Response.new(@client, operation, body)
        end
      end
    end

    # Public: Get the names of all wsdl operations.
    # List all available operations from the partner.wsdl
    def operations
      @client.operations
    end

    def wsdl
      @client.wsdl
    end

    private
    def required_option?
      
    end

    def raise_initialization_error!
      raise InitializationError,
        "Expected either a WSDL document or the SOAP endpoint" \
        "and target namespace options."
    end
  end
end
# rubocop:enable all
