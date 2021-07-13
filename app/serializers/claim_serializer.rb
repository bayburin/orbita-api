class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :type, :description, :status, :priority, :runtime

  has_many :parameters
  has_many :works
  has_many :comments, each_serializer: MessageSerializer
  has_one :source_snapshot

  def runtime
    RuntimeSerializer.new(object.runtime).as_json
  end
end
