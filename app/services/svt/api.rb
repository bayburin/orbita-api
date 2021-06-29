module Svt
  # Содержит API для обращения к СВТ.
  class Api
    include Connection

    API_ENDPOINT = ENV['SVT_URL']

    class << self
      # Возвращает данные о ВТ, найденные по штрих-коду
      def find_by_barcode(barcode)
        connect.get("api/v2/invent/items/#{barcode}")
      end
    end
  end
end
