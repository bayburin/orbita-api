# Преобразует полученный объект фильтров в вид, необходимый для НСИ
class EmployeeFilterAdapter
  # params - объект вида { fullName: { value: 'value', matchMode: 'equals' } }
  def initialize(params)
    @params = params
  end

  def convert
    @params.filter_map do |filter, value_obj|
      filter + searched_value(value_obj) if value_obj['value'].present?
    end.join(';')
  end

  protected

  def searched_value(value_obj)
    match_mode = value_obj['matchMode']
    value = value_obj['value']

    case match_mode
    when 'equals'
      "=='#{value}'"
    when 'contains'
      "=='*#{value}*'"
    end
  end
end
