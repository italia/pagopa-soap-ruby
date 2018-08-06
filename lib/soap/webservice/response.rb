# frozen_string_literal: true

module Soap; end
module Soap::Webservice; end

class Soap::Webservice::Response
  class << self
    protected

    def header_attributes; {} end

    def body_attributes; {} end
  end

  attr_reader :response

  def initialize(response)
    @response = response
    validate_body_attrs!
  end

  def validate_body_attrs!
    return if required_body.empty?
    if !required_body.empty? && attributes.empty?
      raise "Required attributes are missing"
    end

    attributes.each_key do |at|
      if !required_body.include?(at)
        raise "Attribute #{at} must be present"
      end
    end
  end

  def header
    @response.header
  end

  def body
    @response.body
  end

  def decoded_body
    @response.body.to_hash.fetch
  end

  def to_xml
    @response.to_xml
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
