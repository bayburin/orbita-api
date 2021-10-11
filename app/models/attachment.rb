class Attachment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :claim
end
