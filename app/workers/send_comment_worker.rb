# Отправляет все необходимые уведомления всем участникам заявки после обновления заявки.
class SendCommentWorker
  include Sidekiq::Worker

  def perform(claim_id, comment_id)
    claim = Claim.find(claim_id)
    comment = claim.comments.find(comment_id)
    CommentsChannel.broadcast_to claim, MessageSerializer.new(comment)
  end
end
