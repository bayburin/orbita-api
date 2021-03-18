class Guest::Api::V1::SdRequestsController < Guest::Api::V1::BaseController
  def create
    render json: { message: 'ok', user: current_user, token: doorkeeper_token, params: sd_request_params }
  end

  protected

  def sd_request_params
    params.permit(
      :id_tn, # id_tn пользователя, запросившего услугу (в твоем случае это пользователь, который прислал служебку, например)
      :ticket_identity, # Идентификатор типа заявки
      :description, # Свободное описание заявки,
      attrs: {} # Тут можно передать разные параметры наряда, которые будут выводиться в Орбите
    )
  end
end
