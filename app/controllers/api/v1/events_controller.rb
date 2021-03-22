class Api::V1::EventsController < Api::V1::BaseController
  # TODO: Проверить метод после рефакторинга
  def create
    create = Events::Create.call(params: action_params)

    if create.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: create.error, status: :unprocessable_entity
    end
  end

  protected

  def action_params
    params.require(:event).permit(
      :claim_id,
      :event_type,
      :id_tn,
      payload: {}
    )
  end
end
