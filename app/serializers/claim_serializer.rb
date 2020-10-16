class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :app_template_id, :service_name, :app_template_name, :status, :priority, :attrs, :rating, :created_at,
             :runtime

  has_many :works

  def runtime
    ActiveModelSerializers::SerializableResource.new(object.runtime, root: 'runtime').serializable_hash
  end
end
