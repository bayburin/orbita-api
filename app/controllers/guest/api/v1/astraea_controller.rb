class Guest::Api::V1::AstraeaController < Guest::Api::V1::BaseController
  def create
    kase = Astraea::Kase.new(astraea_params)
    sd_request = SdRequest.new(application_id: doorkeeper_token.application.id)
    create = Guest::Astraea::Create.call(
      current_user: current_user,
      form: SdRequests::CreateForm.new(sd_request),
      params: AstraeaAdapterSerializer.new(AstraeaAdapter.new(kase, current_user)).as_json
    )

    if create.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: create.error }, status: :bad_request
    end
  end

  def update
    sd_request = SdRequest
                   .includes(comments: :sender, works: [:group, workers: :user, workflows: :sender])
                   .find_by(integration_id: params[:id], application_id: doorkeeper_token.application.id)
    kase = Astraea::Kase.new(astraea_params)
    update = Guest::Astraea::Update.call(
      current_user: current_user,
      form: SdRequests::UpdateForm.new(sd_request),
      params: AstraeaAdapterSerializer.new(AstraeaAdapter.new(kase, current_user, sd_request)).as_json
    )

    if update.success?
      render json: { message: I18n.t('controllers.api.v1.events.processed_successfully') }
    else
      render json: { error: update.error }, status: :bad_request
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
      :status_id, # статус
      users: [], # массив табельных номеров исполнителей
      messages: [
        :type, # типы: analysis, measure, comment
        :date, # дата создания
        :info # сообщение
      ],
    )
  end
end
