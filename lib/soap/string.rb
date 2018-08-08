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

  def self.wsdl_camelcase(str)
    str_split = str.split("_")
    return str_split.first if str_split.count == 1
    first_split = str_split.delete_at(0)
    last_split = str_split.delete_at(str_split.count - 1)
    if last_split.length <= 3
      last_split.upcase!
    else
      last_split.capitalize!
    end
    "#{first_split}#{str_split.collect(&:capitalize).join}#{last_split}"
  end
end
