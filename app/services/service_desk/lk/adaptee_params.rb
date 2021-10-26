module ServiceDesk
  module Lk
    # Преобразует параметры, полученные из ЛК, в общий вид, необходимый для заявки
    class AdapteeParams
      include Interactor

      delegate :params, :current_user, to: :context

      def call
        params[:source_snapshot] = { id_tn: current_user.id_tn }
        parameter_schema = {
          common: [],
          table: {
            columns: [],
            data: []
          }
        }
        common_params = params[:parameters][:common]
        table_params = params[:parameters][:payload]

        order = 10
        # Заполнение секции common
        common_params.each do |key, val|
          parameter_schema[:common].push(
            key: key,
            value: val,
            desc: desc(key),
            order: order
          )

          order = order + 10
        end

        # Заполнение секции table
        table_params.each_with_index do |str, i|
          if i.zero?
            order = 10
            str.each do |key, val|
              parameter_schema[:table][:columns].push(
                key: key,
                desc: desc(key),
                order: order
              )
            end

            order = order + 10
          end

          parameter_schema[:table][:data].push(str)
        end

        params[:parameter] = {
          schema_version: 1,
          payload: parameter_schema
        }
      end

      def desc(attr)
        case attr.to_s
        when 'tn'
          'Табельный номер'
        when 'fio'
          'ФИО'
        when 'svt_type'
          'Тип ВТ'
        when 'reason'
          'Обоснование'
        when 'invent_num'
          'Инвентарный номер'
        end
      end
    end
  end
end
