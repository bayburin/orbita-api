# Класс, описывающий история действий пользователей системы.
class History < ApplicationRecord
  belongs_to :work
  belongs_to :user
end
