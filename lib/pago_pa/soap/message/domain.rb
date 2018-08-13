# frozen_string_literal: true

module PagoPA; end
module PagoPA::SOAP; end
module PagoPA::SOAP::Message; end

class PagoPA::SOAP::Message::Domain
  REQUIRED_ATTRIBUTES = %i[
    identificativo_dominio identificativo_stazione_richiedente
  ].freeze

  attr_reader :attributes

  def initialize(attributes)
    @attributes = attributes
    validate_attrs!
  end

  def to_params
  end

  private

  def validate_attrs!
    attributes.each_key do |at|
      if !REQUIRED_ATTRIBUTES.include?(at)
        raise "Attribute #{at} must be present"
      end
    end
  end
end
