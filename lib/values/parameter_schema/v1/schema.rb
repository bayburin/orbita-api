module ParameterSchema
  module V1
    # Схема параметров заявки
    class Schema < Dry::Struct
      transform_keys(&:to_sym)

      attribute? :common, Types::Array do
        attribute :key, Types::String
        attribute :key_desc, Types::String
        attribute :value, Types::String | Types::Integer | Types::DateTime
        attribute :value_desc, Types::String | Types::Integer | Types::DateTime
        attribute :order, Types::Integer
      end
      attribute? :table do
        attribute? :columns, Types::Array do
          attribute :key, Types::String # Ключ
          attribute :desc, Types::String # Описание ключа
          attribute :order, Types::Integer
        end
        # attribute? :data, Types::Array.of(Types::Hash)
        attribute? :data, Types::Array do
          attribute :key, Types::String # Ключ
          attribute :value, Types::String # Значение
          attribute :desc, Types::String # Описание значения
        end
      end
    end
  end
end
