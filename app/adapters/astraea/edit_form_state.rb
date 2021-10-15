module Astraea
  class EditFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.model.source_snapshot
    end

    def desc
      nil
    end
  end
end
