# frozen_string_literal: true

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::Payer
  REQUIRED_ATTRIBUTES = %i[
    anagrafica_pagatore identificativo_univoco_pagatore
  ].freeze
  REQUIRED_IUP = %i[
    tipo_identificativo_univoco codice_identificativo_univoco
  ].freeze

  attr_reader :attributes
  attr_reader :iup

  def initialize(attributes = {})
    @attributes = attributes
    @iup = attributes[:identificativo_univoco_pagatore]
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

    iup.each_key do |at|
      if !REQUIRED_IUP.include?(at)
        raise "Attribute Identifier #{at} must be present"
      end
    end
  end
end
