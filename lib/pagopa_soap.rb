# frozen_string_literal: true

require "pagopa_soap/version"
require "pagopa_soap/configurable"
require "pagopa_soap/base"

module PagopaSoap
  class << self
    def options
      Hash[PagopaSoap.keys.map { |key| [key, config.send(key)] }]
    end

    # API client based on configured options {Configurable}
    def client
      return @client if defined?(@client)
      @client = PagopaSoap::Client.new(options)
    end
  end
end
