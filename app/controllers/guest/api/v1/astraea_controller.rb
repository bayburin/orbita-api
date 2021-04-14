class Guest::Api::V1::AstraeaController < Guest::Api::V1::BaseController
  def create
    # create = SdRequests::Create.call(
    #   current_user: current_user,
    #   form: SdRequests::CreateForm.new(SdRequest.new),
    #   params: Astraea::SdRequestAdapter.new(astraea_params).sd_request_params
    # )

    # if create.success?
    #   render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    # else
    #   render json: { error: create.error }, status: :bad_request
    # end

    render json: Astraea::SdRequestAdapter.new(astraea_params).sd_request_params
  end

  protected

  def astraea_params
    params.require(:sd_request).permit(
      :case_id,
      :starttime, # время создания
      :endtime, # время закрытия заявки
      :user_tn, # табельный пользователя
      :host_id, # инвентарный
      :desc, # описание
      :service_id,
      :item_id, # штрих-код
      :phone, # телефон, если ввели вручную
      :time, # время закрытия по плану
      messages: [
        :type, # типы: analysis, measure, comment
        :date, # дата создания
        :info # сообщение
      ],
      users: [
        :user_id # табельный исполнителя
      ]
    )
  end

=begin
Пример запроса:
{
	"id_tn": 12880,
	"sd_request": {
		"case_id": 123,
    "user_tn": 17664,
    "host_id": 765769,
    "desc": "Новая заявка с астреи",
    "service_id": 3,
    "item_id": 100008643,
		"phone": "12-34",
    "time": 1618642512,
		"messages": [],
		"users": [
			{ "user_id": 20072 },
			{ "user_id": 6283 }
		]
	}
}
=end
end
