module SdRequests
  # Создает форму по существующей заявке и обновляет запись в базе в соответствии с полученными параметрами.
  class Update
    include Interactor

    def call
      Rails.logger.debug "Update SdRequest".green
    end
  end
end
