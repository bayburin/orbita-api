# Описывает форму, которая создает заявку.
class ApplicationForm < Reform::Form
  property :id_tn, virtual: true
  property :ip, virtual: true
  property :invent_num, virtual: true

  property :id
  property :service_id
  property :app_template_id
  property :service_name
  property :app_template_name
  property :status, default: ->(**) { :opened }
  property :priority, default: ->(**) { :default }
  property :attrs
  property :source_snapshot, form: SourceSnapshotForm, populate_if_empty: :populate_source_snapshot!
  collection :works, form: WorkForm, populate_if_empty: WorkForm

  def populate_source_snapshot!(_options)
    SourceSnapshotBuilder.build do |ss|
      ss.user_credentials = id_tn
    end
  end
end
