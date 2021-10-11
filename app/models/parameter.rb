# Класс описывает параметры заявки.
class Parameter < ApplicationRecord
  belongs_to :claim
end
