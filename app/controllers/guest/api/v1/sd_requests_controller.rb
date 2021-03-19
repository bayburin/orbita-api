class Guest::Api::V1::SdRequestsController < Guest::Api::V1::BaseController
  def create
    create = Guest::SdRequests::Create.call(
      current_user: current_user,
      params: sd_request_params
    )

    if create.success?
      render json: create.sd_request
    else
      render json: create.error, status: :unprocessable_entity
    end
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
