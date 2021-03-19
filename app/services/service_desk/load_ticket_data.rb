module ServiceDesk
  # Загружает данные по указанному ticket_identity
  class LoadTicketData
    include Interactor

    delegate :params, to: :context

    def call
      response = Api.ticket(params[:ticket_identity])

      if response.success?
        context.ticket = Ticket.new(response.body)
      else
        Rails.logger.warn { "Ошибка: #{response.error}".red }
        context.fail!(error: response.error)
      end
    end
  end
end
