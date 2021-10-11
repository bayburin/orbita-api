class Guest::Api::V1::EventsController < Guest::Api::V1::BaseController
  def create
    claim = Claim.find_by(integration_id: params[:integration_id], application_id: doorkeeper_token.application.id)
    create = Events::Create.call(
      claim: claim,
      user: current_user,
      params: event_params
    )

    if create.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: create.error }, status: :bad_request
    end
  end

  protected

  def event_params
    params.permit(
      :integration_id,
      :id_tn,
      :event_type,
      payload: {}
    )
  end
end
