# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parse
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
    Hash[[ :input, :output ].map do |io|
      [io, {
        port_type: port_type[name][io],
        binding: binding[:operations][name][io],
        types: Hash[message[port_type[name][io][:message].split(":").last][:part].map do |k, part|
          namespace, params = part.split(":")
          [k, types[namespace][params]]
        end]}
      ]
    end]
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
