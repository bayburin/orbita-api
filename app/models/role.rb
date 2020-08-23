# Класс, описывающий пользовательские роли.
class Role < ApplicationRecord
  has_many :users
end
