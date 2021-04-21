module SdRequests
  # Описывает форму, которая обновляет заявку.
  class UpdateForm < SdRequestForm
    property :status

    protected

    def processing_history
      if changed?(:finished_at_plan)
        datetime = Runtime.new(finished_at_plan: finished_at_plan)
        history_store.add(Histories::PostponeType.new(datetime: datetime.finished_at_plan_str).build)
      end

      history_store.add(Histories::PriorityType.new(priority: Claim.translate_enum(:priority, priority)).build) if changed?(:priority)
      super
    end
  end
end
