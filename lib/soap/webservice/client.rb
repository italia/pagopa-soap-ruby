# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Client
  def initialize(endpoint:)
    @endpoint = endpoint
  end

  def send(request)
    @client.call(@endpoint, message: request.to_message)
  end
end
