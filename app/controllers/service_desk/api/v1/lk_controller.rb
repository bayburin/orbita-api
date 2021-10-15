class ServiceDesk::Api::V1::LkController < ServiceDesk::Api::V1::BaseController
  def create_svt_item_request
    create = ServiceDesk::Lk::CreateSvtItemRequest.call(
      current_user: current_user,
      # params: sd_request_params,
      new_files: params[:new_attachments] || []
    )

    if create.success?
      render json: { message: 'ok' }
    else
      render json: create.error, status: :bad_request
    end
  end

  protected

  # def sd_request_params
  #   params.permit(
  #     :id_tn, # id_tn пользователя, запросившего услугу (в твоем случае это пользователь, который прислал служебку, например)
  #   )
  # end
end

=begin
  {
    id_tn: number # идентификатор пользователя
    sd_request: {} # json-строка
    new_attachments: [] # список новых файлов
  }
=end
