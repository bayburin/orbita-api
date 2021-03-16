module AuthCenter
  # Содержит API для обращения к ЦА.
  class Api
    include Connection

    API_ENDPOINT = ENV['AUTH_CENTER_URL']

    class << self
      # Возвращает access_token пользователя.
      def client_token(code)
        body = {
          grant_type: 'authorization_code',
          client_id: ENV['AUTH_CENTER_APP_ID'],
          client_secret: ENV['AUTH_CENTER_APP_SECRET'],
          redirect_uri: ENV['AUTH_CENTER_APP_URL'],
          code: code
        }

        connect.post('/oauth/token', body.to_json)
      end

      # Возвращает access_token приложения.
      def app_token
        body = {
          grant_type: 'client_credentials',
          client_id: ENV['AUTH_CENTER_APP_ID'],
          client_secret: ENV['AUTH_CENTER_APP_SECRET']
        }

        connect.post('/oauth/token', body.to_json)
      end

      # Возвращает данные о текущем пользователе
      def login_info(token)
        connect.get do |req|
          req.url ENV['AUTH_CENTER_LOGIN_INFO']
          req.headers['Authorization'] = "Bearer #{token}"
        end
      end

      # Возвращает данные об указанном хосте
      # search_key = id | ip | mac | name
      def host_info(token, value = '', search_key = 'id')
        connect.get do |req|
          req.params['idfield'] = search_key
          req.params['id'] = value
          req.url ENV['AUTH_CENTER_HOST_INFO']
          req.headers['Authorization'] = "Bearer #{token}"
        end
      end
    end
  end
end
