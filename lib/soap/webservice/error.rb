# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Error < StandardError
  attr_reader :response

  def initialize(response)
    @reseponse = response
  end
end

class Soap::Webservice::GenericError < StandardError
  def initialize
  end
end
