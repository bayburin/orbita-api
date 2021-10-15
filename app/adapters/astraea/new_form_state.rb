module Astraea
  class NewFormState < AbstractFormState
    def initialize(form)
      super form

      @source_snapshot = form.source_snapshot
    end

    def desc
      @form.description
    end
  end
end
