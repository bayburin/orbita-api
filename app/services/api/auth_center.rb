module Api
  # Содержит API для обращения к ЦА.
  class AuthCenter
    include Connection

    API_ENDPOINT = ENV['AUTH_CENTER_URL']

    def self.access_token(code)
      body = {
        grant_type: 'authorization_code',
        client_id: ENV['AUTH_CENTER_APP_ID'],
        client_secret: ENV['AUTH_CENTER_APP_SECRET'],
        redirect_uri: ENV['AUTH_CENTER_APP_URL'],
        code: code
      }

      connect.post('/oauth/token', body.to_json)
    end

    def self.user_info(token)
      connect.get do |req|
        # ? TODO: Возможно понадобится adLogin. В таком случае необходимо перечислить все параметры, которые нужны.
        # req.params['fields'] = 'adLogin'
        req.url '/api/module/main/login_info'
        req.headers['Authorization'] = "Bearer #{token}"
      end
    end
  end
end
