# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parser::Message
  attr_accessor :hash
  attr_reader :node

  def initialize(namespaces, node)
    @node = node
    @hash = {}
  end

  def parse
    parse_message
  end

  def parse_message
    @hash = Hash[@node.map do |node|
      [node['name'], Hash[:part, Hash[node.element_children.map do |mec|
        [mec['name'], mec.attribute('element').value]
      end
      ]]]
    end]
  end
end
