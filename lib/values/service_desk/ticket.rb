module ServiceDesk
  # Модель типа заявки.
  class Ticket < Dry::Struct
    transform_keys(&:to_sym)

    attribute :identity, Types::Integer.optional
    attribute :name, Types::String.optional
    attribute? :sla, Types::Integer.optional
    attribute :service, Types::SdService.optional
  end
end
