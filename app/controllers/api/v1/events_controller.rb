class Api::V1::EventsController < Api::V1::BaseController
  def create
    handler = Events::Handler.call(params: action_params)

    if handler.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: handler.error }, status: :unprocessable_entity
    end
  end

  protected

  def action_params
    params.require(:event).permit(
      :claim_id,
      :event_type,
      :user_name,
      :id_tn,
      payload: {}
    )
  end
end
