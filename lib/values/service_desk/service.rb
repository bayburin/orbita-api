module ServiceDesk
  # Модель услуги.
  class Service
    include Virtus.value_object

    values do
      attribute :id, Integer
      attribute :name, String
    end
  end
end
