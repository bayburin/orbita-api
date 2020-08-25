class HistorySerializer < ActiveModel::Serializer
  attributes :id, :work_id, :user_id, :action, :action_type, :created_at
end
