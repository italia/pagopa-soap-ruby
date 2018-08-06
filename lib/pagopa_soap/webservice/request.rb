# frozen_string_literal: true

# rubocop:disable all
module Pagoparb
  module Webservice
    class Request
      attr_reader :class_name
      attr_reader :parser

      def initialize(class_name, parser)
        @class_name = class_name
        @parser = parser

        build!
        Object.const_set(@class_name, self)
      end

      def build!
        klass = Class.new do
          def initialize(attributes)

          end
        end
      end

    end
  end
end
# rubocop:enable all
