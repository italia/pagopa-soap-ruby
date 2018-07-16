# frozen_string_literal: true

require "savon"
require "pagoparb/version"

require "pagoparb/configurable"
require "pagoparb/client"
require "pagoparb/error"
require "pagoparb/validator"
require "pagoparb/helpers"
require "pagoparb/response"

module Pagoparb
  class << self
    def options
      Hash[Pagoparb.keys.map { |key| [key, config.send(key)] }]
    end

    # API client based on configured options {Configurable}
    def client
      return @client if defined?(@client)
      @client = Pagoparb::Client.new(options)
    end
  end
end
