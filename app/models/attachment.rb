class Attachment < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  validates :attachment, presence: true

  belongs_to :claim
end
