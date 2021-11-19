module SdRequests
  # Создает форму вопроса, историю и запускает все необходимые проверки.
  class ValidateForm
    include Interactor

    delegate :history_store, :form, :current_user, :params, :new_files, to: :context

    def call
      context.history_store = Histories::Storage.new(current_user)
      form.current_user = current_user
      form.history_store = history_store

      # Добавляет новые файлы
      if new_files&.any?
        new_attachments = new_files.map { |file| { attachment: file } }
        (params[:attachments] ||= []).concat(new_attachments)
      end

      context.fail!(error: form.errors.messages) unless form.validate(params)
      context.fail!(error: form.model.errors.messages) unless form.model.valid?
    end
  end
end
