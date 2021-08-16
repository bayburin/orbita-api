module Astraea
  class EditFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.model.source_snapshot
    end

    def case_id
      @form.integration_id
    end

    def user_id
      @source_snapshot.tn
    end

    def phone
      @source_snapshot.user_attrs[:phone]
    end

    def host_id
      @source_snapshot.invent_num
    end

    def barcode
      @source_snapshot.barcode
    end

    def desc
      nil
    end
  end
end
