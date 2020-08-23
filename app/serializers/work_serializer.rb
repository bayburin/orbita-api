class WorkSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :title, :status, :attrs
end
