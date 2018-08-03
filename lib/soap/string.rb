# frozen_string_literal: true

module Soap; end

module Soap::String
  def self.snakecase(str)
    str = str.dup
    str.gsub!(/::/, "/")
    str.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    str.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    str.tr!(".", "_")
    str.tr!("-", "_")
    str.downcase!
    str
  end

  def self.camelcase(str)
    str.split("_").collect(&:capitalize).join
  end
end
