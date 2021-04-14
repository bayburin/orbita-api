class Guest::Api::V1::AstraeaController < Guest::Api::V1::BaseController
  def create
    create = Astraea::Create.call

    if create.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: create.error }, status: :bad_request
    end
  end

  protected

  def astraea_params
    params.require(:sd_request).permit(
      :case_id,
      :service_id,
      :ticket_id,
      :user_tn,
      :id_tn,
      :user_info,
      :host_id,
      :item_id,
      :desc,
      :phone,
      :email,
      :mobile,
      :status_id,
      :status,
      :starttime,
      :endtime,
      :time,
      :sla,
      :accs,
      :runtime,
      :rating
    )
  end
end
