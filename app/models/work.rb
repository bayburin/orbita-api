# Класс, описывающий работу группы по заявке
class Work < ApplicationRecord
  has_many :workers, dependent: :destroy

  belongs_to :claim
end
