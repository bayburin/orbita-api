module Employees
  # Класс выполняет поиск работников в соответствии с фильтрами и возвращает найденных.
  # Если фильтры отсутствуют - возвращается пустой массив
  class Search
    include Interactor

    delegate :filters, :employees, to: :context

    def call
      if filters.keys.none?
        context.employees = []

        return
      end

      converted_filters = EmployeeFilterAdapter.new(filters).convert
      data = Employees::Loader.new(:by_filters).load(converted_filters)
      context.employees = data ? data['data'] : []
    end
  end
end
