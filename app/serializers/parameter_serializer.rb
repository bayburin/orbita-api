class ParameterSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :name, :value

  belongs_to :claim
end
