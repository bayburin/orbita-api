# Описывает форму, которая создает файлы.
class AttachmentForm < Reform::Form
  # Необходимо подключить для того, чтобы форма просто так не помечалась как dirty
  include Sync::SkipUnchanged

  property :id
  property :claim_id
  property :attachment

  validation do
    option :form
    config.messages.backend = :i18n

    params do
      required(:attachment).value(Types::UploadedAttachment)
    end

    rule(:attachment) do
      key.failure(:must_be_less_than_or_equal_to, size: 50) if form.attachment.size > 50.megabytes && !form.id
    end
  end
end
