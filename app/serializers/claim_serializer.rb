class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :service_id, :app_template_id, :service_name, :app_template_name, :status, :priority, :attributes, :rating
end
