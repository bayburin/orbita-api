class CommentsChannel < ApplicationCable::Channel
  def subscribed
    claim = Claim.find(params[:claim_id])

    stream_for claim
  end
end
