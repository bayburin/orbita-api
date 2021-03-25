module SdRequests
  class ValidateUpdateForm
    include Interactor

    delegate :form, :sd_request, :params, to: :context

    def call
      context.form = UpdateForm.new(sd_request)
      context.fail!(error: form.errors.messages) unless form.validate(params)
    end
  end
end
