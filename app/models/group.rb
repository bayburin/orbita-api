# Класс, описывающий группы пользователей (группы, сектора, отделы)
class Group < ApplicationRecord
  has_many :users, dependent: :nullify

  belongs_to :department, optional: true
end
