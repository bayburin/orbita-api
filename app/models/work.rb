# Класс, описывающий работу группы по заявке
class Work < ApplicationRecord
  has_many :workers
  has_many :histories

  belongs_to :claim
end
