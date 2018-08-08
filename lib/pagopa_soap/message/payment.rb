# frozen_string_literal: true

require "pagopa_soap/message/single_payment"

module PagopaSoap; end
module PagopaSoap::Message; end

class PagopaSoap::Message::Payment
  REQUIRED_ATTRIBUTES = %i[
    data_esecuzione_pagamento importo_totale_da_versare tipo_versamento
    identificativo_univoco_versamento codice_contesto_pagamento
    firma_ricevuta dati_singolo_versamento
  ].freeze

  attr_reader :attributes
  attr_reader :date
  attr_reader :amount
  attr_reader :type
  attr_reader :iuv
  attr_reader :contest
  attr_reader :signature

  def initialize(**args)
    @attributes = args
    validate_attrs!

    @date = attributes.delete(:data_esecuzione_pagamento)
    @amount = attributes.delete(:importo_totale_da_versare)
    @type = attributes.delete(:tipo_versamento)
    @iuv = attributes.delete(:identificativo_univoco_versamento)
    @contest = attributes.delete(:codice_contesto_pagamento)
    @signature = attributes.delete(:firma_ricevuta)
  end

  def to_params
  end

  private

  def validate_attrs!
    attributes.each_key do |at|
      if !REQUIRED_ATTRIBUTES.include?(at)
        raise "Attribute #{at} must be present"
      end
    end

    if attributes[:dati_singolo_versamento].count >= 1
      raise "Single payment must be exist"
    end
    if attributes[:dati_singolo_versamento].count > 5
      raise "Single payment can contain up to 5 occurrences"
    end
  end

  def single_payments
    @single_payments ||= attributes[:dati_singolo_versamento].map do |single|
      PagopaSoap::Message::SinglePayment.new(single).perform!
    end
  end
end
