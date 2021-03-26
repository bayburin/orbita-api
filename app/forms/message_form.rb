# Описывает форму, которая создает сообщения.
class MessageForm < Reform::Form
  property :id
  property :claim_id
  property :work_id
  property :sender_id
  property :message

  validation do
    config.messages.backend = :i18n

    params { required(:message).filled }
  end
end
