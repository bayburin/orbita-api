module Comments
  class NotifyOnCreate
    include Interactor

    delegate :claim, :comment, to: :context

    def call
      SendCommentWorker.perform_async(claim.id, comment.id)
    end
  end
end
