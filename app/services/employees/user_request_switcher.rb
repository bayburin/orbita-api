module Employees
  class UserRequestSwitcher
    def self.request(type, token, search_attr)
      case type
      when :load
        # Требуется id_tn
        # Возвращает единственную найденную запись
        Api.load_user(token, search_attr)
      when :by_id_tn
        # Требуется массив id_tn
        # Возвращает массив
        Api.load_users_by_id_tn(token, search_attr.uniq)
      when :by_tn
        # Требуется массив tn
        # Возвращает массив
        Api.load_users_by_tn(token, search_attr.uniq)
      when :by_any
        # Требуется объект вида { field: 'fullname', term: 'FIO' }
        # Возвращает массив
        Api.load_users_like(token, search_attr[:field], search_attr[:term])
      else
        raise 'Неизвестный тип поиска'
      end
    end
  end
end
