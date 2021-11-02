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
          table_data: []
        }

        @payload.common&.each do |el|
          key = el.key
          value = el.value

          result[:common][key] = value
        end

        @payload.table&.data&.each do |el|
          obj = el.reduce({}) do |acc, (key, val)|
            acc[key] = val['value']
            acc
          end
          result[:table_data] << obj
        end

        result
      end
    end
  end
end
