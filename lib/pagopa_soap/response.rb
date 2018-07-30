# frozen_string_literal: true

require "base64"

module Pagoparb
  class Response
    attr_reader :reponse
    attr_reader :method

    def initialize(client, method, body = {})
      client.globals[:endpoint] =
        Pagoparb.options[:endpoint] + client.wsdl.soap_action(method)
      @method = method
      @response = client.call(method, message: body)
    end

    def header
      @response.header
    end

    def body
      @response.body
    end

    def decoded_body
      @response.body.to_hash.fetch()
    end

    def to_xml
      @response.to_xml
    end

    private

    def decode
      
    end
  end
end
