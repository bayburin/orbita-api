module SdRequests
  # Сохраняет форму заявки и историю.
  class Save
    include Interactor

    delegate :form, :history_store, :current_user, to: :context

    def call
      result = false

      ActiveRecord::Base.transaction do
        result = form.save
        form.model.reload

        if result
          history_store.work = form.model.work_for(current_user)
          history_store.save!
        end
      rescue ActiveRecord::RecordNotSaved
        Rails.logger.error { "История не сохранена: #{history_store.histories}".red }
        result = false

        raise ActiveRecord::Rollback
      end

      if result
        context.sd_request = form.model
      else
        context.fail!(error: form.errors.messages)
      end
    end
  end
end
