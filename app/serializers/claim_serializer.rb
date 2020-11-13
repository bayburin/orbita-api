class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :app_template_id, :service_name, :app_template_name, :status, :priority, :attrs, :rating, :runtime, :claim_user

  has_many :works

  def runtime
    ActiveModelSerializers::SerializableResource.new(object.runtime, root: 'runtime').serializable_hash
  end

  def claim_user
    ActiveModelSerializers::SerializableResource.new(object.claim_user, root: 'claim_user').serializable_hash
  end
end
