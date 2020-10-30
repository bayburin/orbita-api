module Api
  # Содержит API для обращения к НСИ.
  class EmployeeApi
    include Connection

    API_ENDPOINT = ENV['EMPLOYEE_DATABASE_URL']

    class << self
      # авторизуется на сервере НСИ. Возвращает токен доступа.
      def login
        connect.post('login') do |req|
          req.headers['X-Auth-Username'] = ENV['EMPLOYEE_DATABASE_USERNAME']
          req.headers['X-Auth-Password'] = ENV['EMPLOYEE_DATABASE_PASSWORD']
        end
      end

      # Получает данные по конкретному работнику.
      def load_user(id_tn)
        connect.get("emp/#{id_tn}") do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.token
        end
      end

      # Получает список работников по их id_tn.
      def load_users_by_id_tn(id_tns)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.token
          req.params['search'] = "id=in=(#{id_tns.join(', ')})"
        end
      end

      # Получает список работников по их tn.
      def load_users_by_tn(tns)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.token
          req.params['search'] = "personnelNo=in=(#{tns.join(', ')})"
        end
      end

      # Получает список работников по указанному параметру.
      def load_users_like(field, str)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = Employees::Authorize.token
          req.params['search'] = "#{field}=='*#{str}*'"
        end
      end
    end
  end
end
