# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parse
  COMMON_ATTRIBUTES = %i(input output)
  attr_reader :document

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
    types = Soap::Parser::Type.new(namespaces, section('types'))
    types.parse
    types.hash
  end

  def port_type
    port_type = Soap::Parser::PortType.new(section('portType'))
    port_type.parse
    port_type.hash
  end

  def binding
    binding = Soap::Parser::Binding.new(section('binding'))
    binding.parse
    binding.hash
  end

  def message
    message = Soap::Parser::Message.new(section('message'))
    message.parse
    message.hash
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
      if v[:part].nil? && v[:parts].nil?
        namespace, params = message[msg_name][:part].values.first.split(":")
        ext[k.to_sym] = types[namespace][params][:params]
      else
        namespace, params = message[msg_name][:part][v[:part] || v[:parts]].split(":")
        ext[k.to_sym] = types[namespace][params][:params]
      end
    end
    ext
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
