class AstraeaAdapterSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :service_name, :ticket_identity, :ticket_name, :description, :priority, :finished_at_plan, :comments

  has_one :source_snapshot
  has_many :works
  has_many :comments

  class SourceSnapshotSerializer < ActiveModel::Serializer
    attributes :svt_item_id, :invent_num, :id_tn, :user_attrs
  end

  class WorkSerializer < ActiveModel::Serializer
    attributes :group_id, :workers
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :message
  end
end
