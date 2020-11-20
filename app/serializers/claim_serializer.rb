class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :type, :status, :priority, :attrs, :runtime

  has_many :works
  has_one :source_snapshot

  def runtime
    RuntimeSerializer.new(object.runtime).as_json
  end
end
