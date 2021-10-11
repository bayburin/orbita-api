module ServiceDesk
  # Модель типа заявки.
  class Ticket < Dry::Struct
    transform_keys(&:to_sym)

    attribute? :id, Types::Integer.optional
    attribute :identity, Types::Integer.optional
    attribute :name, Types::String.optional
    attribute :service, Types::SdService.optional
    attribute? :sla, Types::Integer.optional
    attribute? :responsible_users, Types::Array.of(Types::Hash.schema(tn: Types::Coercible::Integer)).constructor { |arr| arr.map(&:symbolize_keys) }
  end
end
