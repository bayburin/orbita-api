module SdRequests
  class SaveUpdateForm
    include Interactor

    delegate :form, to: :context

    def call
      if form.save
        context.sd_request = form.model.reload
        SdRequests::UpdatedWorker.perform_async(context.sd_request.id)
      else
        context.fail!(error: form.errors)
      end
    end
  end
end
