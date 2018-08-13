# frozen_string_literal: true

require "savon"

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Client
  class << self
    def endpoint
      "#{namespace}#{action}"
    end
  end

  def client
    @client ||=
      Savon.client(
        endpoint: self.class.endpoint,
        namespace: self.class.namespace,
        convert_request_keys_to: :none,
        pretty_print_xml: true,
        follow_redirects: true,
        headers: {
          "User-Agent" =>
            "Ruby Wrapper for pagoPA (#{PagoPA::SOAP::VERSION})",
          "Cache-Control" => "no-cache",
          "Accept-Encoding" => "gzip, deflate"
        }
      )
  end

  def send(request)
    response.new(
      client.call(Soap.to_snakecase(self.class.action), request.to_message)
    )
  end
end
