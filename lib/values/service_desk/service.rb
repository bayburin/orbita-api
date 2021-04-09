module ServiceDesk
  # Модель услуги.
  class Service < Dry::Struct
    transform_keys(&:to_sym)

    attribute :id, Types::Integer.optional
    attribute :name, Types::String.optional
  end
end
