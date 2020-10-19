# Описывает форму, которая создает работу по заявке.
class WorkForm < Reform::Form
  property :id
  property :claim_id
  property :title
  property :status
  property :attrs
end
