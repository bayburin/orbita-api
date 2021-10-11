class Api::V1::CommentsController < Api::V1::BaseController
  def create
    create = Comments::Create.call(
      claim: Claim.find(params[:claim_id]),
      current_user: current_user,
      params: params
    )

    if create.success?
      render json: { message: 'ok' }
    else
      render json: create.error, status: :bad_request
    end
  end
end
