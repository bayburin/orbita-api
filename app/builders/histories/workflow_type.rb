module Histories
  # Создает историю с типом workflow
  class WorkflowType < BaseBuilder
    TYPE = 'workflow'.freeze

    def build
      HistoryBuilder.build { |h| h.set_event_type(TYPE, workflow: params[:workflow]) }
    end
  end
end
