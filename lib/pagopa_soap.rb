# frozen_string_literal: true

require "nori"
require "gyoku"

require "pagopa_soap/version"
require "soap"
require "pagopa_soap/configurable"
require "pagopa_soap/base"
require "pagopa_soap/message/rpt"
require "pagopa_soap/message/rt"

module PagopaSoap
  class << self
    def options
      Hash[PagopaSoap.keys.map { |key| [key, config.send(key)] }]
    end

    # API client based on configured options {Configurable}
    def build
      return @build if defined?(@build)
      @build = PagopaSoap::Base.new(options)
    end
  end
end
