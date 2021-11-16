module Astraea
  class EditFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.model.source_snapshot
    end

    def case_id
      @form.model.claim_applications.find_by(application_id: Doorkeeper::Application.find_by(name: 'Astraea').id).integration_id
    end

    def desc
      nil
    end
  end
end
