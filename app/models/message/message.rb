# Класс, описывающий все виды сообщений в заявке.
class Message < ApplicationRecord
  belongs_to :claim
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
end
