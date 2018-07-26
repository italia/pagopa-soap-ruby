# frozen_string_literal: true

module Pagoparb
  module Parser
    class Type
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
                if !node.children.blank?
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
          elem_attributes = Hash[[ :nillable, :default, :minOccurs, :maxOccurs ].map do |attr|
            [attr.to_s, inner.attribute(attr.to_s).to_s] if inner.attribute(attr.to_s)
          end]
          element[name][:params] << {:name => elem_name, :type => elem_type, :attributes => elem_attributes}
        end

        node.xpath('./xsd:sequence/xsd:element').each do |inner|
          elem_name = inner.attribute('name').value
          elem_type = inner.attribute('type').value
          elem_attributes = Hash[[ :nillable, :default, :minOccurs, :maxOccurs ].map do |attr|
            [attr.to_s, inner.attribute(attr.to_s).to_s] if inner.attribute(attr.to_s)
          end]
          element[name][:params] << {:name => elem_name, :type => elem_type, :attributes => elem_attributes}
        end

        element
      end

      private

      def schemas
        types = @node.first
        types ? types.element_children : []
      end
    end
  end
end
