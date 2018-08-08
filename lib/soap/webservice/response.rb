# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Response
  class << self
    def header_attributes; {} end

    def body_attributes; {} end
  end

  attr_reader :response
  attr_reader :errors

  def initialize(response)
    @response = response
    @errors = []

    validate_errors!
    validate_body_attrs!
  end

  # rubocop:disable all
  def validate_errors!
    case response.http.code
    when 200
      errors << Soap::Webservice::FaultError.new(response)
    when 500
      errors << Soap::Webservice::Error.new(response)
    else
      errors << Soap::Webservice::GenericError.new(response)
    end
  end
  # rubocop:enable all

  def validate_body_attrs!
    return if required_body.empty?
    if !required_body.empty? && attributes.empty?
      raise "Required attributes are missing #{required_body}"
    end

    if !(required_body - attributes.keys).empty?
      raise "Attribute #{required_body - attributes.keys} must be present"
    end
  end

  def header
    response.header
  end

  def body
    response.body
  end

  def decoded_body
    response.body
  end

  def to_xml
    response.to_xml
  end

  private

  def list_body_attrs
    return {} if self.class.body_attributes.nil?
    self.class.body_attributes.each.with_object(
      required: [],
      optional: []
    ) do |attr, attrs|
      name = Soap.to_snakecase(attr[:name]).to_sym
      if attr[:attributes].empty?
        attrs[:required] << name
      else
        attrs[:optional] << name
      end
    end
  end

  def required_body
    list_body_attrs[:required] || []
  end

  def required_attrs
    required_body
  end
end
