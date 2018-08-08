# frozen_string_literal: true

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::Domain
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
