class Guest::Api::V1::EventsController < Guest::Api::V1::BaseController
  def create
    claim = ClaimsQuery.new.search_by_integration(doorkeeper_token.application.id, params[:integration_id]).first
    create = Events::Create.call(
      claim: claim,
      user: current_user,
      event_type: params[:event_type],
      payload: params[:payload],
      files: params[:files],
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
      :payload,
      files: [],
      payload: {},
    )
  end
end
