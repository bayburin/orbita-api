class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :claim_id, :attachment, :filename

  def filename
    object.attachment.file.filename
  end
end
