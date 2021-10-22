class Api::V1::EventsController < Api::V1::BaseController
  def create
    create = Events::Create.call(
      claim: Claim.find(event_params[:claim_id]),
      user: current_user,
      event_type: params[:event_type],
      payload: params[:payload],
      need_update_astraea: true
    )

    if create.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: create.error }, status: :bad_request
    end
  end

  protected

  def event_params
    params.require(:event).permit(
      :claim_id,
      :event_type,
      :id_tn,
      payload: {}
    )
  end
end
