module Employees
  class UserRequestSwitcher
    def self.request(type, search_attr)
      case type
      when :load
        Api::EmployeeApi.load_user(search_attr)
      when :by_id_tn
        Api::EmployeeApi.load_users_by_id_tn(search_attr.uniq)
      when :by_tn
        Api::EmployeeApi.load_users_by_tn(search_attr.uniq)
      when :by_any
        Api::EmployeeApi.load_users_like(search_attr[:field], search_attr[:term])
      end
    end
  end
end
