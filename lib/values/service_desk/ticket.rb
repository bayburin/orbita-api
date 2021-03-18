module ServiceDesk
  # Модель типа заявки.
  class Ticket
    include Virtus.value_object

    values do
      attribute :id, Integer
      attribute :identity, Integer
      attribute :service_id, Integer
      attribute :name, String
      attribute :sla, Integer
      attribute :service, Service
    end
  end
end
