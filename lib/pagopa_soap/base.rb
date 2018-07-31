# frozen_string_literal: true

module PagopaSoap; end

class PagopaSoap::Base
  attr_reader :wsdl
  attr_reader :namespace

  def initialize(options = {})
    @wsdl = options[:wsdl] || PagopaSoap.config.wsdl
    @namespace = options[:namespace] || PagopaSoap.config.namespace

    validate_wsdl!
  end

  def build
    soap_base.build
  end

  def clients
    soap_base.clients
  end

  private

  def soap_base
    @soap_base ||= Soap::Base.new(wsdl: wsdl, namespace: namespace)
  end

  def validate_wsdl!
    raise "Error: WSDL is empty" if !@wsdl.instance_of?(String)
    raise "Error: File not exists" if !File.exists?(@wsdl)
    return
  end
end
