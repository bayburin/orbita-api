module JobInfo
  # Содержит API для обращения к Astraea.
  class Api
    include Connection

    API_ENDPOINT = ENV['INFO_JOB_URL']

    class << self
      # Возвращает, сколько часов была открыта заявка/кейс
      def claim_work_time(tn, start_date, end_date)
        connect.get('get_case_work_time') do |req|
          req.params['tn'] = tn
          req.params['start_date'] = start_date
          req.params['end_date'] = end_date
        end
      end

      # Возвращает дату, когда должна быть закрыта заявка/кейс
      def claim_end_time(tn, start_date, hours)
        connect.get('get_case_end_time') do |req|
          req.params['tn'] = tn
          req.params['start_date'] = start_date
          req.params['hours'] = hours
        end
      end
    end
  end
end
