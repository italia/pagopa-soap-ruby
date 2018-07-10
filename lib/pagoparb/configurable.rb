# frozen_string_literal: true

module Pagoparb
  class Configurable
    attr_accessor :host
    attr_accessor :endpoint
    attr_accessor :logger
    attr_accessor :tag_style

    def initialize
      @host = nil
      @endpoint = nil
      @logger = nil
      @tag_style ||= :snakecase
    end

    class << self
      # List of configurable keys for {Pagoparb::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :host,
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
  end
end
