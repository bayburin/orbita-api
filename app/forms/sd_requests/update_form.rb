module SdRequests
  # Описывает форму, которая обновляет заявку.
  class UpdateForm < SdRequestForm
    protected

    def processing_history
      # if model.finished_at_plan_changed?
      #   history = HistoryBuilder.build { |h| h.set_event_type(:postpone, { datetime: model.runtime.finished_at_plan_str }) }
      #   history_store.add(history)
      # end

      # if model.priority_changed?
      #   history = HistoryBuilder.build { |h| h.set_event_type(:priority, { priority: model.priority }) }
      #   history_store.add(history)
      # end
    end
  end
end
