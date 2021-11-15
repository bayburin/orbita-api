class ClaimApplicationSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :application_id, :integration_id
end
