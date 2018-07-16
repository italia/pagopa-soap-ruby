# frozen_string_literal: true

module Pagoparb
  class << self
    # List of configurable keys for {Pagoparb::Client}
    # @return [Array] of option keys
    def keys
      @keys ||= [
        :namespace,
        :endpoint,
        :logger,
        :tag_style
      ]
    end

    def config
      @config ||= Configurable.new
    end

    # Set configuration options using a block
    def configure
      yield(config)
    end
  end

  class Configurable
    attr_accessor :namespace
    attr_accessor :endpoint
    attr_accessor :logger
    attr_accessor :tag_style

    def initialize
      @namespace = nil
      @endpoint = nil
      @logger ||= Logger.new(STDOUT)
      @tag_style ||= :snakecase
    end
  end
end
