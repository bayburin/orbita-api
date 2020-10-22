# Класс, описывающий все виды сообщений в заявке.
class Message < ApplicationRecord
  belongs_to :claim
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'

  def as_json(options = {})
    # as_json Coerces self to a hash for JSON encoding.
    # https://apidock.com/rails/ActiveResource/Base/as_json
    super(options.merge(methods: :type))
  end
end
