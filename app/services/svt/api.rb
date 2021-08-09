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

      # Возвращает данные о ВТ в соответствии с фильтрами
      def query_items(filters)
        connect.get('api/v2/invent/search_items') do |req|
          filters.each do |key, value|
            req.params[key] = value
          end
        end
      end
    end
  end
end
