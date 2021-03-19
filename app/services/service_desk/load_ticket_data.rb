module ServiceDesk
  # Загружает данные по указанному ticket_id
  class LoadTicketData
    include Interactor

    def call
      response = Api.ticket(context.identity)

      if response.success?
        context.ticket = Ticket.new(response.body)
      else
        Rails.logger.warn { "Ошибка: #{response.error}".red }
        context.fail!(error: response.error)
      end
    end
  end
end
