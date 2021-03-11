module SdRequests
  # Создает форму вопроса и сохраняет в базе.
  class Save
    include Interactor

    delegate :create_form, :history_store, :current_user, to: :context

    def call
      result = false

      ActiveRecord::Base.transaction do
        result = create_form.save

        if result
          history_store.work = create_form.model.work_for(current_user)
          history_store.save!
        end
      rescue ActiveRecord::RecordNotSaved
        Rails.logger.error { "История не сохранена: #{history_store.histories}".red }
        result = false

        raise ActiveRecord::Rollback
      end

      if result
        context.sd_request = create_form.model
      else
        context.fail!(errors: create_form.errors)
      end
    end
  end
end