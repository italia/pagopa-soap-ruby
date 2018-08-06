# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parser::PortType
  attr_accessor :hash
  attr_reader :node

  def initialize(_namespaces, node)
    @node = node
    @hash = {}
  end

  def parse
    parse_port_types
  end

  def parse_port_types
    return if @node.empty? && @node.first.nil?
    node_elements =
      node.first.element_children.select do |op|
        op.name == "operation"
      end

    @hash = Hash[node_elements.map do |operation|
      [operation["name"], {
        input: parse_input_or_output(operation, "input"),
        output: parse_input_or_output(operation, "output")
      }]
    end]
  end

  def parse_input_or_output(node, type)
    node_type = node.element_children.find { |n| n.name == type }
    {
      name: node_type.attribute("name").value,
      message: node_type.attribute("message").value,
      action: node_type.attribute("Action").value
    }
  end
end
