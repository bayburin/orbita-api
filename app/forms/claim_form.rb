# Описывает форму, которая создает заявку.
class ClaimForm < Reform::Form
  property :id
  property :service_id
  property :app_template_id
  property :service_name
  property :app_template_name
  property :status
  property :priority
  property :id_tn
  property :tn
  property :fio
  property :dept
  property :user_details
  property :attrs
  collection :works, form: WorkForm, populate_if_empty: WorkForm
end
