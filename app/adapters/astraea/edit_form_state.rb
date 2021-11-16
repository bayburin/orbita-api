module Astraea
  class EditFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.model.source_snapshot
    end

    def case_id
      @form.model.integration_id_for('Astraea')
    end

    def desc
      nil
    end
  end
end
