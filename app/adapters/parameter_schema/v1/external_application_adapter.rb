module ParameterSchema
  module V1
    # Схема параметров заявки для отправки во внешнюю систему
    class ExternalApplicationAdapter
      def initialize(payload)
        @payload = payload
      end

      def adaptee
        result = {
          common: {},
          table_data: {}
        }

        @payload.common&.each do |el|
          key = el.key
          value = el.value

          result[:common][key] = value
        end

        @payload.table&.data&.each do |el|
          key = el.key
          value = el.value

          result[:table_data][key] = value
        end

        result
      end
    end
  end
end
