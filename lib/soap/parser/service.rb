# frozen_string_literal: true

module Soap; end
module Soap::Parser; end

class Soap::Parser::Service
  attr_accessor :hash
  attr_reader :node

  def initialize(_namespaces, node)
    @node = node
    @hash = {}
  end

  def parse
    parse_service
  end

  def parse_service
    address = node.first.at_xpath("./wsdl:port/soap:address")
    @hash = {
      base_endpoint: address["location"]
    }
  end
end
