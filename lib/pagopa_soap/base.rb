# frozen_string_literal: true

module PagopaSoap; end

class PagopaSoap::Base
  attr_reader :wsdl_base
  attr_reader :wsdl_notify
  attr_reader :namespace

  def initialize(options = {})
    @wsdl_base = options[:wsdl_base] || PagopaSoap.config.wsdl_base
    @wsdl_notify = options[:wsdl_notify] || PagopaSoap.config.wsdl_notify
    @namespace = options[:namespace] || PagopaSoap.config.namespace

    validate_wsdl_base!
    validate_wsdl_notify!
  end

  def build
    soap_base.build
    soap_notify.build
  end

  def requests
    soap_base.request + soap_notify.request
  end

  def clients
    soap_base.client + soap_notify.client
  end

  def responses
    soap_base.response + soap_notify.response
  end

  private

  def soap_base
    @soap_base ||=
      Soap::Base.new(
        wsdl: wsdl_base,
        namespace: namespace,
        endpoint: PagopaSoap.config.endpoint_base
      )
  end

  def soap_notify
    @soap_notify ||=
      Soap::Base.new(
        wsdl: wsdl_notify,
        namespace: namespace,
        endpoint: PagopaSoap.config.endpoint_notify
      )
  end

  def validate_wsdl_base!
    raise "Error: WSDL is empty" if !@wsdl_base.instance_of?(String)
    raise "Error: File not exists" if !File.exists?(@wsdl_base)
  end

  def validate_wsdl_notify!
    raise "Error: WSDL is empty" if !@wsdl_notify.instance_of?(String)
    raise "Error: File not exists" if !File.exists?(@wsdl_notify)
  end
end
