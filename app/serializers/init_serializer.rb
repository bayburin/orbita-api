class InitSerializer < ActiveModel::Serializer
  has_many :users
  has_many :groups
  has_many :event_types
  has_many :applications, each_serializer: Doorkeeper::ApplicationSerializer
end
