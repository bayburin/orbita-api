module SdRequests
  # Создает форму вопроса, историю и запускает все необходимые проверки.
  class ValidateForm
    include Interactor

    delegate :history_store, :form, :current_user, :params, to: :context

    def call
      context.history_store = Histories::Storage.new(current_user)
      form.current_user = current_user
      form.history_store = history_store
      context.fail!(error: form.errors.messages) unless form.validate(params)
    end
  end
end
