# frozen_string_literal: true

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::Rt
  class << self
    def decode(string)
      Base64.decode64(string)
    end
  end

  REQUIRED_ATTRIBUTES = %i[
    versione_oggetto dominio identificativo_messaggio_ricevuta
    data_ora_messaggio_richiesta riferimento_messaggio_richiesta
    riferimento_data_richiesta istituto_attestante ente_beneficiario
    soggetto_pagatore dati_pagamento
  ].freeze

  attr_reader :attributes

  def initialize(attributes = {}, decode = false)
    if decode && attributes.key?(:base_64)
      parser = Nori.new(
        advanced_typecasting: false,
        convert_tags_to: lambda { |tag| Soap.to_nakecase(tag).to_sym }
      )
      attrs = parser.parse(self.decode(attributes[:base_64] || ""))
      @attributes = attrs || {}
    else
      @attributes = attributes
    end
  end

  def encode
    Base64.encode64(to_xml)
  end

  def to_xml
    Gyoku.xml(to_params)
  end
end
