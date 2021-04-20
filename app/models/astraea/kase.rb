module Astraea
  # Класс описывает заявку системы Astraea
  class Kase < Dry::Struct
    transform_keys(&:to_sym)

    attribute :case_id, Types::Coercible::Integer
    attribute :user_tn, Types::Coercible::Integer # табельный пользователя
    attribute :id_tn, Types::Coercible::Integer # id_tn пользователя
    attribute :host_id, Types::String # инвентарный
    attribute? :desc, Types::String # описание
    attribute? :service_id, Types::Coercible::Integer.optional
    attribute? :ticket_id, Types::Coercible::Integer.optional
    attribute :item_id, Types::Coercible::Integer # штрих-код
    attribute :phone, Types::String.optional # телефон, если ввели вручную
    attribute :time, Types::Integer # время закрытия по плану (timestamp)
    attribute :severity, Types::String.enum('high' => '3', 'default' => '4', 'low' => '6') # приоритет
    attribute :status_id, Types::String.enum('Не обработано' => 1, 'В работе' => 2, 'Выполнено' => 3, 'Отклонено' => 5) # статус
    attribute :users, Types::Instance(ActiveRecord::Relation).constructor { |tns| User.where(tn: tns) } # массив табельных номеров исполнителей
    attribute :messages, Types::Array.of(Types::Hash.schema(type: Types::String, info: Types::String)).constructor { |arr| arr.map(&:symbolize_keys) } # массив сообщений
  end
end
