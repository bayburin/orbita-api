class Api::V1::Dept821Controller < Api::V1::BaseController
  def create
    create = Claims::Place821.call(params: claim_params)

    if create.success?
      render json: create.claim
    else
      render json: create.errors, status: :unprocessable_entity
    end
  end

  protected

  def claim_params
    params.require(:dept821).permit(:tn, attrs: {})
  end
end
