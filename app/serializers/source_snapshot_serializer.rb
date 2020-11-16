class SourceSnapshotSerializer < ActiveModel::Serializer
  attributes :id, :claim_user

  def claim_user
    ActiveModelSerializers::SerializableResource.new(object.claim_user, root: 'claim_user').serializable_hash
  end
end
