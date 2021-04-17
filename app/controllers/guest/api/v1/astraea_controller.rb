class Guest::Api::V1::AstraeaController < Guest::Api::V1::BaseController
  def create
    kase = Astraea::Kase.new(astraea_params)
    create = SdRequests::Create.call(
      current_user: current_user,
      form: SdRequests::CreateForm.new(SdRequest.new),
      params: AstraeaAdapterSerializer.new(AstraeaAdapter.new(kase, current_user)).as_json
    )

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
      :starttime, # время создания
      :endtime, # время закрытия заявки
      :user_tn, # табельный пользователя
      :id_tn, # id_tn пользователя
      :host_id, # инвентарный
      :desc, # описание
      :service_id,
      :ticket_id,
      :item_id, # штрих-код
      :phone, # телефон, если ввели вручную
      :time, # время закрытия по плану
      :severity, # приоритет
      users: [], # массив табельных номеров исполнителей
      messages: [
        :type, # типы: analysis, measure, comment
        :date, # дата создания
        :info # сообщение
      ],
    )
  end

=begin
Пример запроса:
{
	"id_tn": 12880,
	"sd_request": {
		"case_id": "104",
		"user_tn": "17935",
		"id_tn": "19750",
		"host_id": "765769",
		"desc": "Новая заявка с астреи",
		"item_id": "100008643",
		"phone": "12-34",
		"time": 1618642512,
		"severity": "6",
		"users": [20072, 6283],
		"messages": [
			{
				"type": "comment",
				"info": "Комментарий с астреи"
			}
		]
	}
}

При изменении:
id_tn
sd_request: {
      :case_id,
      :severity,
      :user_tn # табельный пользователя
      :host_id # инвентарный
      :item_id # штрих-код
      :phone # телефон, если ввели вручную
      messages: [
        :type, # типы: analysis, measure, comment
        :date, # дата создания
        :info # сообщение
      ],
      :time # время контроля
      users: [
        :user_id # табельный исполнителя
      ]
}
=end
end
