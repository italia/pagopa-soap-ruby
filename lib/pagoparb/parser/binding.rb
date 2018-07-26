# frozen_string_literal: true

module Pagoparb
  module Parser
    class Binding
      attr_accessor :hash
      attr_reader :node

      def initialize(node)
        @node = node
        @hash = {}
      end

      def parse
        parse_binding
      end

      def parse_binding
        return if @node.blank?
        binding_node = @node.first

        @hash[:name] = binding_node['name']
        @hash[:type] = binding_node['type']
        operations = Hash[binding_node.xpath('./wsdl:operation').map do |operation|
          [operation['name'], {
            :input => parse_input_output(operation, 'input'),
            :output => parse_input_output(operation, 'output')
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
        attributes = {}
        [ :part, :message ].map do |attr|
          attributes[attr] = node.attribute(attr.to_s).value if !node.attribute(attr.to_s).blank?
        end

        attributes[:name] = node.parent['name']
        if !node.attribute('parts').blank?
          attributes[:part] = node.attribute('parts').value
        end

        attributes
      end
    end
  end
end
