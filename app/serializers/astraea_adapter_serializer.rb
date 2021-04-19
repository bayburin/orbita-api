class AstraeaAdapterSerializer < ActiveModel::Serializer
  attributes :integration_id, :service_id, :service_name, :ticket_identity, :ticket_name, :description, :priority, :finished_at_plan, :comments

  has_one :source_snapshot
  has_many :works
  has_many :comments

  class SourceSnapshotSerializer < ActiveModel::Serializer
    attributes :svt_item_id, :invent_num, :id_tn, :user_attrs
  end

  class WorkSerializer < ActiveModel::Serializer
    attributes :group_id, :workers, :workflows

    def workers
      ActiveModelSerializers::SerializableResource.new(object.workers, each_serializer: WorkerSerializer).serializable_hash
    end

    def workflows
      ActiveModelSerializers::SerializableResource.new(object.workflows, each_serializer: WorkflowSerializer).serializable_hash
    end

    class WorkerSerializer < ActiveModel::Serializer
      attributes :user_id
    end

    class WorkflowSerializer < ActiveModel::Serializer
      attributes :message
    end
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :message
  end
end
