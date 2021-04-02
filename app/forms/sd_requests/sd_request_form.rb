module SdRequests
  # Описывает базовую форму заявки.
  class SdRequestForm < Reform::Form
    feature Coercion

    property :id
    property :priority, default: ->(**) { Claim.default_priority }
    property :finished_at_plan, type: Types::Params::DateTime, default: ->(**) { Claim.default_finished_at_plan }
    collection :parameters, form: ParameterForm, populate_if_empty: Parameter
    collection :works, form: WorkForm, populator: :populate_works!
    collection :attachments, form: AttachmentForm
    collection :comments, form: MessageForm, populator: :populate_comments!

    attr_accessor :current_user, :history_store

    validation do
      option :form
      config.messages.backend = :i18n

      params { optional(:works) }

      rule(:works) do
        key.failure(:duplicate_groups) if value.map { |work| work[:group_id] }.uniq.count != value.count
      end
    end

    def validate(params)
      result = super(params)
      processing_history
      result
    end

    # Обработка списка работ
    def populate_works!(fragment:, **)
      item = works.find { |work| work.id == fragment[:id].to_i }

      (item || works.append(Work.new)).tap do |w|
        w.current_user = current_user
        w.history_store = history_store
      end
    end

    # Обработка списка комментариев
    def populate_comments!(fragment:, **)
      return skip! if fragment[:id]

      history_store.add(Histories::CommentType.new(comment: fragment[:message]).build)
      comments.append(Comment.new(sender: current_user))
    end

    protected

    def processing_history; end
  end
end
