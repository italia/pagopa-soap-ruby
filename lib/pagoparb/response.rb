# frozen_string_literal: true

require "nori"
require "base64"

module Pagoparb
  class Response
    attr_reader :reponse

    def initialize(client, method, body)
      @response = client.call(method, message: body)
    end

    def header
      @response.header
    end

    def to_xml
      @response.to_xml
    end

    private

    def nori
      return @nori if @nori

      nori_options = {
        delete_namespace_attributes: @globals[:delete_namespace_attributes],
        strip_namespaces: @globals[:strip_namespaces],
        convert_tags_to: @globals[:convert_response_tags_to],
        convert_attributes_to: @globals[:convert_attributes_to],
        advanced_typecasting: @locals[:advanced_typecasting],
        parser: @locals[:response_parser]
      }

      non_nil_nori_options = nori_options.reject { |_, value| value.nil? }
      @nori = Nori.new(non_nil_nori_options)
    end
  end
end
