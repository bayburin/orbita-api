module Employees
  # Предоставляет интерфейс для обращения к API НСИ.
  class Employee
    STOP_COUNTER = 2

    def initialize(type)
      @type = type
      @counter = 0
    end

    def load(params)
      if @counter == STOP_COUNTER
        @counter = 0
        return nil
      end

      @counter += 1
      Authorize.token || Authorize.authorize
      response = UserRequestSwitcher.request(@type, params)
      if response.success?
        @counter = 0
        response.body
      else
        Authorize.clear
        load(params)
      end
    end
  end
end
