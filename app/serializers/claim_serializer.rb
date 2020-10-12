class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :app_template_id, :service_name, :app_template_name, :status, :priority, :attrs, :rating

  has_many :works
end
