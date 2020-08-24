class UserAcl < ApplicationRecord
  belongs_to :user
  belongs_to :acl
end
