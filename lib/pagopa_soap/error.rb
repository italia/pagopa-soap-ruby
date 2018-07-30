# frozen_string_literal: true

module Pagoparb
  class Error < StandardError
    attr_reader :fault

    def initialize(fault)
      super(fault[:code] || fault[:faultcode])
      @fault = fault
    end
  end
end
