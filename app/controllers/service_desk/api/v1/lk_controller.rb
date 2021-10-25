class ServiceDesk::Api::V1::LkController < ServiceDesk::Api::V1::BaseController
  def create_svt_item_request
    create = ServiceDesk::Lk::CreateSvtItemRequest.call(
      current_user: current_user,
      params: sd_request_params,
      doorkeeper_token: doorkeeper_token,
      new_files: params[:new_attachments] || []
    )

    if create.success?
      render json: { message: 'ok' }
    else
      render json: create.error, status: :bad_request
    end
  end

  protected

  def sd_request_params
    ActionController::Parameters.new(JSON.parse(params[:sd_request])).permit(
      :ticket_identity,
      :integration_id,
      :description,
      parameters: [:common, :payload]
    )
  end
end

=begin
  {
    id_tn: number # идентификатор пользователя
    sd_request: sd_request_params # json-строка
    new_attachments: [] # список новых файлов
  }
=end
