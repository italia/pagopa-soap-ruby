# frozen_string_literal: true

module PagopaSoap; end

class PagopaSoap::Base
  attr_reader :wsdl
  attr_reader :namespace

  def initialize(options = {})
    @wsdl = options[:wsdl] || File.expand_path("../../resources/nodo_per_pa.wsdl", __dir__)
    @namespace = options[:namespace] || "PagoPa"

    validate_wsdl!
  end

  def build
    sbase = Soap::Base.new(wsdl: @wsdl, namespace: @namespace)
    sbase.build
  end

  private

  def validate_wsdl!
    raise "Error: WSDL is empty" if !@wsdl.instance_of?(String)
    raise "Error: File not exists" if !File.exists?(@wsdl)
    return
  end
end
