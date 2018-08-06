# frozen_string_literal: true

# rubocop:disable all
module Pagopa
  class Error < StandardError
    attr_reader :fault

    def initialize(fault)
      super(fault[:code] || fault[:faultcode])
      @fault = fault
    end
  end
end
# rubocop:enable all
