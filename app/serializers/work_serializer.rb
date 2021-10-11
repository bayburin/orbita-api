class WorkSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :group_id

  has_many :workers
  has_many :histories
  has_many :workflows, each_serializer: MessageSerializer

  belongs_to :group
end
