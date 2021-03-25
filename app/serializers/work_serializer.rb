class WorkSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :group_id

  has_many :workers
  has_many :histories

  belongs_to :group
end
