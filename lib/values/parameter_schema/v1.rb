module ParameterSchema
  class V1 < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :common, Types::Array do
      attribute :key, Types::String
      attribute :value, Types::String | Types::Integer
      attribute :desc, Types::String
      attribute :order, Types::Integer
    end
    attribute? :table do
      attribute? :columns, Types::Array do
        attribute :key, Types::String
        attribute :desc, Types::String
        attribute :order, Types::Integer
      end
      attribute? :data, Types::Array.of(Types::Hash)
    end
  end
end
