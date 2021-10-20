class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :attachment, :filename

  def filename
    object.attachment.filename
  end
end
