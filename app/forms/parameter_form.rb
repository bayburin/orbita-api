# Описывает форму параметров заявки.
class ParameterForm < Reform::Form
  property :id
  property :claim_id
  property :name
  property :value

  validation do
    config.messages.backend = :i18n

    params { required(:name).filled }
  end
end
