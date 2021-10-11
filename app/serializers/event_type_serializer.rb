class EventTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_public
end
