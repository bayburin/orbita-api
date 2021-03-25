# Описывает форму, которая создает файлы.
class AttachmentForm < Reform::Form
  property :id
  property :claim_id
  property :attachment

  # TODO: обавить проверку на наличие файла: https://github.com/musaffa/file_validators
end
