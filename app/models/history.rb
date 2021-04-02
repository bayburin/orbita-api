# Класс, описывающий история действий пользователей системы.
class History < ApplicationRecord
  belongs_to :work
  belongs_to :user
  belongs_to :event_type

  attr_accessor :order
end
