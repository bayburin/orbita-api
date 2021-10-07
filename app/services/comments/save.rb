module Comments
  class Save
    include Interactor

    delegate :current_user, :params, to: :context

    def call
      form = MessageForm.new(Comment.new)
      context.fail!(error: form.errors.messages) unless form.validate(params.merge(sender_id: current_user.id)) && form.save
      context.comment = form.model
    end
  end
end
