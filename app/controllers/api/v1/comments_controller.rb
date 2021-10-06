class Api::V1::CommentsController < Api::V1::BaseController
  def create
    claim = Claim.find(params[:claim_id])
    comment = claim.comments.new(message: params[:message], sender: current_user)

    if comment.save
      render json: { message: 'ok' }
      SendCommentWorker.perform_async(claim.id, comment.id)
    else
      render json: { error: comment.errors }
    end
  end
end
