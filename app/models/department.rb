class Department < ApplicationRecord
  has_many :groups, dependent: :destroy
end
