# Класс, описывающий работу группы по заявке.
class Work < ApplicationRecord
  has_many :workers, dependent: :destroy
  has_many :users, through: :workers
  has_many :histories, dependent: :destroy
  has_many :workflows, dependent: :destroy

  belongs_to :claim
  belongs_to :group

  enum status: { in_processing: 1, done: 2, expired: 3 }, _suffix: true
end
