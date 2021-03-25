module SdRequests
  # Описывает базовую форму заявки.
  class SdRequestForm < Reform::Form
    feature Coercion

    property :id
    property :priority, default: ->(**) { Claim.default_priority }
    property :attrs
    property :finished_at_plan, type: Types::Params::DateTime, default: ->(**) { Claim.default_finished_at_plan }
    collection :works, form: WorkForm, populator: :populate_works!
    collection :attachments, form: AttachmentForm, populate_if_empty: Attachment

    attr_accessor :current_user, :history_store

    validation do
      option :form
      config.messages.backend = :i18n

      params { optional(:works) }

      rule(:works) do
        key.failure(:duplicate_groups) if value.map { |work| work[:group_id] }.uniq.count != value.count
      end
    end

    def sync
      result = super
      processing_history
      result
    end

    # Обработка списка работ
    def populate_works!(fragment:, **)
      item = works.find { |work| work.id == fragment[:id].to_i }

      item || works.append(Work.new)
    end

    protected

    def processing_history; end
  end
end
