# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parser::Type
  VALIDATION_ATTRIBUTES = %i(nillable default minOccurs maxOccurs)

  attr_accessor :hash
  attr_reader :node
  attr_reader :namespaces

  def initialize(namespaces, node)
    @namespaces = namespaces
    @node = node
    @hash = {}
  end

  def parse
    parse_types
  end

  def parse_types
    schemas.each do |schema|
      namespace = @namespaces.key(schema["targetNamespace"])
      @hash[namespace] = {}
      schema.element_children.each do |node|
        case node.name
          when "element"
            if !node.children.empty?
              node_type = node.at_xpath('./xsd:complexType')
              @hash[namespace].merge!(parse_type(node_type, node['name']))
            end
          when "complexType"
            @hash[namespace].merge!(parse_type(node, node['name']))
        end
      end
    end
  end

  def simple_type
    {'base' => @node.at_xpath('./xs|xsd:restriction')['base']}
  end

  def parse_type(node, name)
    element = {}
    element[name] ||= {:params => []}
    node.xpath('./xsd:complexContent/xsd:extension/xsd:sequence/xsd:element').each do |inner|
      elem_name = inner.attribute('name').value
      elem_type = inner.attribute('type').value
      elem_attributes =
        Soap::Parser::Type::VALIDATION_ATTRIBUTES.each.with_object({}) do |attr, attrs|
          value = inner.attribute(attr.to_s)
          attrs[attr] = value.to_s if value
        end

      element[name][:params] << {
        name: elem_name,
        type: elem_type,
        attributes: elem_attributes
      }
    end

    node.xpath('./xsd:sequence/xsd:element').each do |inner|
      elem_name = inner.attribute('name').value
      elem_type = inner.attribute('type').value
      elem_attributes =
        Soap::Parser::Type::VALIDATION_ATTRIBUTES.each.with_object({}) do |attr, attrs|
          value = inner.attribute(attr.to_s)
          attrs[attr] = value.to_s if value
        end

      element[name][:params] << {
        name: elem_name,
        type: elem_type,
        attributes: elem_attributes
      }
    end

    element
  end

  private

  def schemas
    return [] if @node.empty? && @node.first.nil?
    types = @node.first
    types ? types.element_children : []
  end
end
