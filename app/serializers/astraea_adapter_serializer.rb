class AstraeaAdapterSerializer < ActiveModel::Serializer
  attributes :integration_id, :service_id, :service_name, :ticket_identity, :ticket_name, :description, :status, :priority, :finished_at_plan, :comments

  has_one :source_snapshot
  has_many :works
  has_many :comments

  class SourceSnapshotSerializer < ActiveModel::Serializer
    attributes :id, :svt_item_id, :invent_num, :id_tn, :user_attrs
  end

  class WorkSerializer < ActiveModel::Serializer
    attributes :id, :group_id, :workers, :workflows

    def workers
      ActiveModelSerializers::SerializableResource.new(object.workers, each_serializer: WorkerSerializer).serializable_hash
    end

    def workflows
      ActiveModelSerializers::SerializableResource.new(object.workflows, each_serializer: WorkflowSerializer).serializable_hash
    end

    class WorkerSerializer < ActiveModel::Serializer
      attributes :id, :user_id, :_destroy
    end

    class WorkflowSerializer < ActiveModel::Serializer
      attributes :id, :message
    end
  end

  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :message
  end
end
