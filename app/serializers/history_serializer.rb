class HistorySerializer < ActiveModel::Serializer
  attributes :id, :work_id, :user_id, :event_type_id, :action, :created_at

  belongs_to :event_type
end
