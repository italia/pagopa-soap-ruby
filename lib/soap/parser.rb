# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parse
  COMMON_ATTRIBUTES = %i[input output].freeze
  DEFAULT_SECTIONS = %w[types message port_type binding service].freeze
  attr_reader :document

  def initialize(file)
    @document = Nokogiri::XML(file)
  end

  def namespaces
    @namespaces = @document.namespaces.inject({}) do |memo, (key, value)|
      memo[key.sub("xmlns:", "")] = value
      memo
    end
  end

  DEFAULT_SECTIONS.each do |sec|
    define_method(sec.to_sym) do
      sec_klass = Object.const_get("Soap::Parser::#{Soap.to_camelcase(sec)}")
      sec_result = sec_klass.new(namespaces, section(sec))
      sec_result.parse
      sec_result.hash
    end
  end

  def soap_actions
    port_type.keys.map do |pt|
      pt
    end
  end

  def soap_action(name)
    Soap::Parse::COMMON_ATTRIBUTES.each.with_object({}) do |common, attrs|
      attrs[common] = {
        port_type: port_type[name][common],
        binding: binding[:operations][name][common],
        message: message[port_type[name][common][:message].split(":").last],
        types: extract_types_attribute(name, common)
      }
    end
  end

  def extract_types_attribute(name, io)
    msg_name = port_type[name][io][:message].split(":").last
    components = binding[:operations][name][io]
    ext = {}
    components.map do |k, v|
      component = message[msg_name][:part]
      if v[:part].nil? && v[:parts].nil?
        namespace, params = component.values.first.split(":")
      else
        namespace, params = component[v[:part] || v[:parts]].split(":")
      end
      ext[k.to_sym] = types[namespace][params][:params]
    end
    ext
  end

  def section(section_name)
    sections[section_name] || []
  end

  def sections
    @sections ||=
      @document.root.element_children.each.with_object({}) do |node, attrs|
        (attrs[Soap.to_snakecase(node.name)] ||= []) << node
      end
  end
end
