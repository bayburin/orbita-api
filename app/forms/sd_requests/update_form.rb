module SdRequests
  # Описывает форму, которая обновляет заявку.
  class UpdateForm < Reform::Form
    property :id
    property :description
    property :status, default: ->(**) { Claim.default_status }
    property :priority, default: ->(**) { Claim.default_priority }
    property :attrs
    property :finished_at_plan, default: ->(**) { Claim.default_finished_at_plan }
    property :current_user, virtual: true
    collection :users, virtual: true
    collection :works, form: WorkForm
    collection :attachments, form: AttachmentForm, populate_if_empty: Attachment
  end
end
