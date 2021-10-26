# Описывает форму параметров заявки.
class ParameterForm < Reform::Form
  property :id
  property :claim_id
  property :schema_version
  property :payload

  def schema_version
    super || 1
  end
end
