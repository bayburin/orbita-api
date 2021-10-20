module ServiceDesk
  # Загружает данные по указанному ticket_identity
  class LoadTicketData
    include Interactor

    delegate :params, to: :context

    def call
      response = Api.ticket_by_identity(params[:ticket_identity])

      if response.success?
        context.ticket = Ticket.new(response.body)
      else
        Rails.logger.warn { "Ошибка: #{response.body}".red }
        context.fail!(error: response.body)
      end
    end
  end
end
