class ParameterSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :schema_version, :payload
end
