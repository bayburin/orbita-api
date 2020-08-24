# Класс, описывающий работников, выполняющих работы по заявке.
class Worker < ApplicationRecord
  belongs_to :work
  belongs_to :user
end
