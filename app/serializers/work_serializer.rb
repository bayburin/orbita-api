class WorkSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :title, :status, :attrs

  has_many :users
  has_many :histories
end
