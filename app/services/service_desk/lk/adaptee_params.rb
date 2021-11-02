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
            key_desc: desc_key(key),
            value: val,
            value_desc: desc_value(val),
            order: order
          )

          order = order + 10
        end

        # Заполнение секции table
        table_params.each_with_index do |hash, i|
          if i.zero?
            order = 10
            hash.each do |key, val|
              parameter_schema[:table][:columns].push(
                key: key,
                desc: desc_key(key),
                order: order
              )
            end

            order = order + 10
          end

          obj = hash.reduce({}) do |acc, (key, val)|
            acc[key] = {
              value: val,
              desc: desc_value(val)
            }
            acc
          end
          parameter_schema[:table][:data].push(obj)
        end

        params[:parameter] = {
          schema_version: 1,
          payload: parameter_schema
        }
      end

      def desc_key(attr)
        case attr.to_s
        when 'tn' then 'Табельный номер'
        when 'fio' then 'ФИО'
        when 'type' then 'Тип ВТ'
        when 'reason' then 'Обоснование'
        when 'invent_num' then 'Инвентарный номер'
        when 'arrears_ids' then 'Список РМ с задолжностями'
        else attr
        end
      end

      def desc_value(attr)
        case attr.to_s
        when 'pc' then 'Компьютер'
        when 'allin1' then 'Моноблок'
        when 'notebook' then 'Ноутбук'
        else attr
        end
      end
    end
  end
end
