class WorkSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :title, :status, :attrs

  has_many :workers
  has_many :histories

  belongs_to :group
end
