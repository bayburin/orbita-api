class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :application_id, :type, :description, :status, :priority, :runtime

  has_many :works
  has_many :comments, each_serializer: MessageSerializer
  has_many :attachments
  has_many :claim_applications
  has_one :parameter
  has_one :source_snapshot

  def runtime
    RuntimeSerializer.new(object.runtime).as_json
  end
end
