class SourceSnapshotSerializer < ActiveModel::Serializer
  attributes :id, :svt_item_id, :user, :host

  def user
    ActiveModelSerializers::SerializableResource.new(object.user, root: 'user').serializable_hash
  end

  def host
    ActiveModelSerializers::SerializableResource.new(object.host, root: 'host').serializable_hash
  end
end
