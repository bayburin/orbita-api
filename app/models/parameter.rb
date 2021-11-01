# Класс описывает параметры заявки.
class Parameter < ApplicationRecord
  belongs_to :claim

  def payload_data
    "ParameterSchema::V#{schema_version}::Schema".constantize.new(payload)
  end

  def payload_for_external_app
    "ParameterSchema::V#{schema_version}::ExternalApplicationAdapter".constantize.new(payload_data).adaptee
  end
end
