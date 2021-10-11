module ServiceDesk
  # Содержит API для обращения к порталу техподдержки.
  class Api
    include Connection

    API_ENDPOINT = ENV['SERVICE_DESK_URL']

    # Возвращает объект заявки, найденный по id.
    def self.ticket(id)
      connect.get("tickets/#{id}")
    end

    # Возвращает объект заявки, найденный по identity.
    def self.ticket_by_identity(identity)
      connect.get("tickets/identity/#{identity}")
    end
  end
end
