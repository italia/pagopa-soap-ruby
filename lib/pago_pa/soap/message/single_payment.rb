# frozen_string_literal: true

module PagoPA; end
module PagoPA::SOAP; end
module PagoPA::SOAP::Message; end

class PagoPA::SOAP::Message::SinglePayment
  REQUIRED_ATTRIBUTES = %i[].freeze

  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end

  def to_params
  end
end
