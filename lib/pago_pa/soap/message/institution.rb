# frozen_string_literal: true

module PagoPA; end
module PagoPA::SOAP; end
module PagoPA::SOAP::Message; end

class PagoPA::SOAP::Message::Institution
  REQUIRED_ATTRIBUTES = %i[
    denominazione_beneficiario identificativo_univoco_beneficiario
  ].freeze
  REQUIRED_IUB = %i[
    tipo_identificativo_univoco codice_identificativo_univoco
  ].freeze

  attr_reader :attributes
  attr_reader :iub

  def initialize(attributes)
    @attributes = attributes
    @iub = attributes[:identificativo_univoco_beneficiario]
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

    iub.each_key do |at|
      if !REQUIRED_IUB.include?(at)
        raise "Attribute Identifier #{at} must be present"
      end
    end
  end
end
