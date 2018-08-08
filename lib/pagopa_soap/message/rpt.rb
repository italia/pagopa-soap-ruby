# frozen_string_literal: true

require "pagopa_soap/message/domain"
require "pagopa_soap/message/payer"
require "pagopa_soap/message/institution"
require "pagopa_soap/message/payment"

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::Rpt
  class << self
    def decode(string)
      nori = Nori.new(
        advanced_typecasting: false,
        convert_tags_to: lambda do |tag|
          Soap.to_snakecase(tag.split(":").last).to_sym
        end
      )
      xml = Base64.decode64(string)
      nori.parse(xml)
    end
  end

  REQUIRED_ATTRIBUTES = %i[
    versione_oggetto dominio identificativo_messaggio_richiesta
    data_ora_messaggio_richiesta autenticazione_soggetto
    soggetto_pagatore ente_beneficiario dati_versamento
  ].freeze

  attr_reader :attributes
  attr_reader :version
  attr_reader :request_id
  attr_reader :date_request
  attr_reader :auth
  attr_reader :base_64

  def initialize(decode = false, **args)
    if decode && args.key?(:base_64)
      args = self.decode(args[:base_64] || "")
    end

    @attributes = args
    @version = attributes.delete(:versione_oggetto)
    @request_id = attributes.delete(:identificativo_messaggio_richiesta)
    @date_request = attributes.delete(:data_ora_messaggio_richiesta)
    @auth = attributes.delete(:autenticazione_soggetto)
  end

  def to_params
    {
      "RPT" => {}
    }
  end

  def encode
    Base64.encode64(to_xml)
  end

  def to_xml
    Gyoku.xml(to_params)
  end

  private

  def domain
    @domain ||= PagoSoap::Message::Domain.new(attributes[:dominio]).perform!
  end

  def payer
    @payer ||=
      PagoSoap::Message::Payer.new(attributes[:soggetto_pagatore]).perform!
  end

  def institution
    @institution ||=
      PagoSoap::Message::Institution.new(
        attributes[:ente_beneficiario]
      ).perform!
  end

  def payment
    @payment ||=
      PagoSoap::Message::Payment.new(attributes[:dati_versamento]).perform!
  end
end
