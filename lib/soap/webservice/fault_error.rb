# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::FaultError
  attr_reader :response

  def initialize(response)
    @response = response
  end
end
