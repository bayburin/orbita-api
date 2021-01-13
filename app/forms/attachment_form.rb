# Описывает форму, которая создает файлы.
class AttachmentForm < Reform::Form
  property :id
  property :claim_id
  property :attachment

  validates :attachment, presence: true
end
