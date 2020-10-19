# Описывает форму, которая создает заявку.
class ClaimForm < Reform::Form
  property :id
  property :service_id
  property :app_template_id
  property :service_name
  property :app_template_name
  property :status, default: ->(**) { :opened }
  property :priority, default: ->(**) { :default }
  property :id_tn
  property :tn
  property :fio
  property :dept
  property :user_details
  property :attrs
  collection :works, form: WorkForm, populate_if_empty: WorkForm
end
