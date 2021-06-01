class InitSerializer < ActiveModel::Serializer
  has_many :users
  has_many :groups
  has_many :event_types
end
