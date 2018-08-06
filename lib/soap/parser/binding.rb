# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parser::Binding
  COMPONENT_ATTRIBUTES = %i[part parts message].freeze
  attr_accessor :hash
  attr_reader :node

  def initialize(_namespaces, node)
    @node = node
    @hash = {}
  end

  def parse
    parse_binding
  end

  def parse_binding
    return if @node.empty? && @node.first.nil?
    binding_node = @node.first

    @hash[:name] = binding_node["name"]
    @hash[:type] = binding_node["type"]
    operations = Hash[binding_node.xpath("./wsdl:operation").map do |operation|
      [operation["name"], {
        input: parse_input_output(operation, "input"),
        output: parse_input_output(operation, "output")
      }]
    end]
    @hash[:operations] = operations
  end

  def parse_input_output(node, type)
    type_node = node.element_children.find { |ec| ec.name == type }

    Hash[type_node.element_children.map do |elem|
      [elem.name, parse_attribute(elem)]
    end]
  end

  def parse_attribute(node)
    attributes =
      COMPONENT_ATTRIBUTES.each.with_object({}) do |attr, attrs|
        value = node.attribute(attr.to_s)
        attrs[attr] = value.to_s if value
      end
    attributes[:name] = node.parent["name"]

    attributes
  end
end
