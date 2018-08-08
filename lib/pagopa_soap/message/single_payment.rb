# frozen_string_literal: true

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::SinglePayment
  REQUIRED_ATTRIBUTES = %i[].freeze

  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end

  def to_params
  end
end
