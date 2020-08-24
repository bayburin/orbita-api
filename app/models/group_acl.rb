# Класс, описывающий acl для роли и группы.
class GroupAcl < ApplicationRecord
  belongs_to :role
  belongs_to :group
  belongs_to :acl
end
