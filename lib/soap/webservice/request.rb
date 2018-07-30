# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Request
  def initialize(attributes = {})
    @attributes = attributes
    validate_attributes!
  end

  def validate_attributes!
     
  end

  def body_params

  end

  def header_params

  end

  def to_message

  end

  def to_xml

  end
end
