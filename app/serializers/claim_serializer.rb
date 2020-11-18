class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :status, :priority, :attrs, :runtime

  has_many :works
  has_one :source_snapshot

  def runtime
    ActiveModelSerializers::SerializableResource.new(object.runtime, root: 'runtime').serializable_hash
  end
end
