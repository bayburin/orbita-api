module Histories
  class BaseBuilder
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def build
      raise 'Метод неопределен'
    end
  end
end
