# Класс, описывающий группы пользователей (группы, сектора, отделы)
class Group < ApplicationRecord
  has_many :users, dependent: :nullify
end
