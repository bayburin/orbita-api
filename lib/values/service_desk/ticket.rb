module ServiceDesk
  # Модель типа заявки.
  class Ticket
    include Virtus.value_object

    values do
      attribute :identity, Integer
      attribute :name, String
      attribute :sla, Integer
      attribute :service, Service
    end
  end
end
