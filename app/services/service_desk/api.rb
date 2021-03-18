module ServiceDesk
  # Содержит API для обращения к порталу техподдержки.
  class Api
    include Connection

    API_ENDPOINT = ENV['SERVICE_DESK_URL']

    # Возвращает объект заявки.
    def self.ticket(id)
      connect.get("tickets/#{id}")
    end
  end
end
