module SdRequests
  # Описывает форму, которая обновляет заявку.
  class UpdateForm < Reform::Form
    feature Coercion

    property :id
    property :priority, default: ->(**) { Claim.default_priority }
    property :attrs
    property :finished_at_plan, type: Types::Params::DateTime, default: ->(**) { Claim.default_finished_at_plan }
    collection :works, form: WorkForm, populator: :populate_works!
    collection :attachments, form: AttachmentForm, populate_if_empty: Attachment

    validation do
      option :form
      config.messages.backend = :i18n

      params { optional(:works) }

      rule(:works) do
        key.failure(:duplicate_groups) if value.map { |work| work[:group_id] }.uniq.count != value.count
      end
    end

    # Обработка списка работ
    def populate_works!(fragment:, **)
      item = works.find { |work| work.id == fragment[:id].to_i }

      item || works.append(Work.new)
    end
  end
end
