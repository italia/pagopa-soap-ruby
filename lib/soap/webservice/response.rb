# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Response
  def initialize(attributes = {})
    @attributes = attributes
    validate_attributes!
  end

  def validate_attributes!
     
  end
end
