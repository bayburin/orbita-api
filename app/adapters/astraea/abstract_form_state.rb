module Astraea
  class AbstractFormState
    def initialize(form)
      @form = form
    end

    def case_id
      raise 'Необходимо реализовать метод case_id'
    end

    def user_id
      raise 'Необходимо реализовать метод user_id'
    end

    def phone
      raise 'Необходимо реализовать метод phone'
    end

    def host_id
      raise 'Необходимо реализовать метод host_id'
    end

    def barcode
      raise 'Необходимо реализовать метод barcode'
    end

    def desc
      raise 'Необходимо реализовать метод desc'
    end
  end
end
