class MessageSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :work_id, :sender_id, :type, :message, :created_at

  belongs_to :sender
end
