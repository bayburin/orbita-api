module SdRequests
  # Создает форму вопроса и сохраняет в базе.
  class Create
    include Interactor

    def call
      create_form = SdRequestForm.new(context.sd_request || SdRequest.new)

      if create_form.validate(context.params) && create_form.save
        context.sd_request = create_form.model
      else
        context.fail!(errors: create_form.errors)
      end
    end
  end
end
