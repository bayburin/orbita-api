module JobInfo
  class CalculateClaimEndTime
    def initialize(tn, start_time, hours)
      @tn = tn
      @start_time = start_time
      @hours = hours
    end

    def calculate
      Rails.logger.debug "Hours: #{@hours}"
      response = Api.claim_end_time(@tn, @start_time, @hours)

      if response.success?
        Time.parse(response.body['data']).in_time_zone('Asia/Krasnoyarsk')
      else
        Rails.logger.error { "Не удалось получить дедлайн. Устанавливается время по умолчанию. Ошибка: #{response.body['message']}" }
        nil
      end
    end
  end
end
