module SdRequests
  # Создает форму вопроса, историю и запускает все необходимые проверки.
  class Build
    include Interactor

    delegate :history_store, :create_form, :current_user, to: :context

    def call
      context.history_store = Histories::Storage.new
      context.create_form = SdRequestForm.new(context.sd_request || SdRequest.new)
      context.create_form.current_user = current_user

      if create_form.validate(context.params)
        history = HistoryBuilder.build do |h|
          h.set_event_type(:created)
          h.user = current_user
        end
        history_store.add(history)
      else
        context.fail!(errors: create_form.errors)
      end
    end
  end
end
