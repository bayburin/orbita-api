class WorkerSerializer < ActiveModel::Serializer
  attributes :id, :work_id, :user_id

  belongs_to :user
end
