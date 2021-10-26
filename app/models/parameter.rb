# Класс описывает параметры заявки.
class Parameter < ApplicationRecord
  belongs_to :claim

  def payload_data
    "ParameterSchema::V#{schema_version}".constantize.new(payload)
  end
end
