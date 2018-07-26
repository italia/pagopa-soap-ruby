# frozen_string_literal: true

require 'pagoparb/core_ext/string'

module Pagoparb
  module Parser
    class Xml
      attr_reader :document
      attr_reader :parser

      def initialize(document)
        @document = document
        sections
      end

      def namespaces
        @namespaces = @document.namespaces.inject({}) do |memo, (key, value)|
          memo[key.sub('xmlns:', '')] = value
          memo
        end
      end

      def types
        types = Pagoparb::Parser::Type.new(namespaces, section('types'))
        types.parse
        types.hash
      end

      def port_type
        port_type = Pagoparb::Parser::PortType.new(section('portType'))
        port_type.parse
        port_type.hash
      end

      def binding
        binding = Pagoparb::Parser::Binding.new(section('binding'))
        binding.parse
        binding.hash
      end

      def message
        message = Pagoparb::Parser::Message.new(section('message'))
        message.parse
        message.hash
      end

      def soap_actions
        port_type.keys.map do |pt|
          Pagoparb::CoreExt::String.snakecase(pt).to_sym
        end
      end

      private

      def section(section_name)
        @sections[section_name] || []
      end

      def sections
        return @sections if @sections
        @sections = {}
        @document.root.element_children.each do |node|
          (@sections[node.name] ||= []) << node
        end
      end
    end
  end
end
