module Astraea
  class NewFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.source_snapshot
    end

    def case_id
      @form.integration_id
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
      @form.description
    end
  end
end
