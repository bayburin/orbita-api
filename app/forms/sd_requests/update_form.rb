module SdRequests
  # Описывает форму, которая обновляет заявку.
  class UpdateForm < SdRequestForm
    property :status

    protected

    def processing_history
      # Если исполнитель сам подключился к работе, добавить соответствеющую запись события
      works.each do |work|
        current_worker = work.workers.find { |worker| worker.user_id == current_user.id }

        if current_worker && !current_worker.model.id
          history_store.add(Histories::AddSelfType.new.build)
        end
      end

      if changed?(:finished_at_plan)
        datetime = Runtime.new(finished_at_plan: Time.zone.parse(finished_at_plan))
        history_store.add(Histories::PostponeType.new(datetime: datetime.finished_at_plan_str).build)
      end

      history_store.add(Histories::PriorityType.new(priority: Claim.translate_enum(:priority, priority)).build) if changed?(:priority)
      super
    end
  end
end
