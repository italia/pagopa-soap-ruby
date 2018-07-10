# frozen_string_literal: true

require "savon"
require "pagoparb/version"

require "pagoparb/configurable"
require "pagoparb/client"
require "pagoparb/error"
require "pagoparb/validator"
require "pagoparb/helpers"

module Pagoparb
  class << self
    def host
      Configurable.config.host
    end

    def logger
      Configurable.config.logger
    end

    def tag_style
      Configurable.config.tag_style
    end

    def endpoint
      Configurable.config.endpoint
    end

    def options
      Hash[Pagoparb::Configurable.keys.map{|key| [key, send(key)]}]
    end

    # API client based on configured options {Configurable}
    def client
      return @client if defined?(@client)
      @client = Pagoparb::Client.new(options)
    end
  end
end
