module SdRequests
  class SaveUpdateForm
    include Interactor

    delegate :form, to: :context

    def call
      if form.save
        context.sd_request = form.model.reload
      else
        context.fail!(error: form.errors)
      end
    end
  end
end
