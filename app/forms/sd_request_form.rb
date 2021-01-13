# Описывает форму, которая создает заявку.
class SdRequestForm < Reform::Form
  property :id
  property :service_id
  property :app_template_id
  property :service_name
  property :app_template_name
  property :description
  property :status, default: ->(**) { :opened }
  property :priority, default: ->(**) { :default }
  property :attrs
  property :source_snapshot, form: SourceSnapshotForm, populator: :populate_source_snapshot!
  collection :works, form: WorkForm, populate_if_empty: Work, populator: :populate_works!
  collection :attachments, form: AttachmentForm, populate_if_empty: Attachment

  validates :service_name, :attrs, presence: true

  # Обработка источника заявки
  def populate_source_snapshot!(fragment:, **)
    self.source_snapshot = SourceSnapshotBuilder.build do |ss|
      ss.user_credentials = fragment[:id_tn] if fragment[:id_tn]
    end
  end

  # Обработка списка работ
  def populate_works!(fragment:, **)
    item = works.find { |work| work.id == fragment[:id].to_i }

    item || works.append(Work.new)
  end
end
