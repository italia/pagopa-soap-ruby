# frozen_string_literal: true

require "savon"

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Client
  attr_reader :endpoint
  attr_accessor :response
  attr_reader :client

  def initialize(endpoint:, response:)
    @endpoint = endpoint
    @response = response

    @client =
      Savon.client(
        endpoint: endpoint,
        convert_request_keys_to: :none,
        pretty_print_xml: true,
        follow_redirects: true,
        headers: {
          "User-Agent" => "Ruby Wrapper pagoPA (#{PagopaSoap::VERSION})",
          "Cache-Control" => "no-cache",
          "Accept-Encoding" => "gzip, deflate"
        }
      )
  end

  def send(request)
    response.new(client.call(endpoint, request.to_message))
  end
end
