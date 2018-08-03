# frozen_string_literal: true

require "gyoku"

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Request
  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
    validate_header_attrs!
    validate_body_attrs!
  end

  def validate_header_attrs!
    return if required_header.empty?
    raise "Required attributes are missing" if !required_header.empty? &&
      attributes.empty?
    attributes.each_key do |at|
      if !required_header.include?(at)
        raise "Attribute #{at} must be present"
      end
    end
  end

  def validate_body_attrs!
    return if required_body.empty?
    raise "Required attributes are missing" if !required_body.empty? &&
      attributes.empty?
    attributes.each_key do |at|
      if !required_body.include?(at)
        raise "Attribute #{at} must be present"
      end
    end
  end

  def body_params
    self.class.body_attributes.each.with_object({}) do |attr, attrs|
      name = Soap.to_snakecase(attr[:name]).to_sym
      value = attributes[name]
      attrs[name] = value if value
    end
  end

  def header_params
    self.class.header_attributes.each.with_object({}) do |attr, attrs|
      name = Soap.to_snakecase(attr[:name]).to_sym
      value = attributes[name]
      attrs[name] = value if value
    end
  end

  def to_message
    {
      soap_header: header_params,
      message: body_params,
    }
  end

  def to_xml
    Gyoku.xml(
      to_message,
      key_converter: lambda { |key| key.camelize(:lower) }
    )
  end

  protected

  def self.header_attributes; {} end
  def self.body_attributes; {} end

  private

  def list_header_attrs
    return {} if self.class.header_attributes.nil?
    self.class.header_attributes.each.with_object({
      required: [],
      optional: []
    }) do |attr, attrs|
      name = Soap.to_snakecase(attr[:name]).to_sym
      if attr[:attributes].empty?
        attrs[:required] << name
      else
        attrs[:optional] << name
      end
    end
  end

  def list_body_attrs
    return {} if self.class.body_attributes.nil?
    self.class.body_attributes.each.with_object({
      required: [],
      optional: []
    }) do |attr, attrs|
      name = Soap.to_snakecase(attr[:name]).to_sym
      if attr[:attributes].empty?
        attrs[:required] << name
      else
        attrs[:optional] << name
      end
    end
  end

  def required_header
    list_header_attrs[:required] || []
  end

  def required_body
    list_body_attrs[:required] || []
  end

  def required_attrs
    required_header + required_body
  end
end
