class Api::V1::Dept821Controller < Api::V1::BaseController
  def create
    claim_form = ClaimForm.new(Claim.new)

    if claim_form.validate(claim_params) && claim_form.save
      render json: claim_form.model
    else
      render json: { error: claim.form.errors }, status: :unprocessable_entity
    end
  end

  protected

  def claim_params
    params.require(:claim).permit(
      :id,
      :service_id,
      :app_template_id,
      :priority,
      :tn,
      :attrs
    )
  end
end
