module Employees
  # Содержит API для обращения к НСИ.
  class Api
    include Connection

    API_ENDPOINT = ENV['EMPLOYEE_DATABASE_URL']

    class << self
      # Авторизуется на сервере НСИ. Возвращает токен доступа.
      def token
        connect.post('login') do |req|
          req.headers['X-Auth-Username'] = ENV['EMPLOYEE_DATABASE_USERNAME']
          req.headers['X-Auth-Password'] = ENV['EMPLOYEE_DATABASE_PASSWORD']
        end
      end

      # Получает данные по конкретному работнику.
      def load_user(token, id_tn)
        connect.get("emp/#{id_tn}") do |req|
          req.headers['X-Auth-Token'] = token
        end
      end

      # Получает данные по внешнему работнику.
      def load_foreign_user(token, id_tn)
        connect.get("foreign-emp/#{id_tn}") do |req|
          req.headers['X-Auth-Token'] = token
        end
      end

      # Получает список работников по их id_tn.
      def load_users_by_id_tn(token, id_tns)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = token
          req.params['search'] = "id=in=(#{id_tns.join(', ')})"
        end
      end

      # Получает список работников по их tn.
      def load_users_by_tn(token, tns)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = token
          req.params['search'] = "personnelNo=in=(#{tns.join(', ')})"
        end
      end

      # Получает список работников по указанному параметру.
      def load_users_like(token, field, str)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = token
          req.params['search'] = "#{field}=='*#{str}*'"
        end
      end

      # Получается список работников по списку параметров
      def search(token, filters)
        connect.get('emp') do |req|
          req.headers['X-Auth-Token'] = token
          req.params['search'] = filters
        end
      end
    end
  end
end
