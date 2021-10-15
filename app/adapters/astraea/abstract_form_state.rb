module Astraea
  class AbstractFormState
    def initialize(form)
      @form = form
    end

    def case_id
      @form.integration_id
    end

    def user_tn
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
      raise 'Необходимо реализовать метод desc'
    end
  end
end
