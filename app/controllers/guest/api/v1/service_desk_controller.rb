class Guest::Api::V1::ServiceDeskController < Guest::Api::V1::BaseController
  def create
    render json: { params: app_params }
  end

  protected

  def app_params
    params.require(:app).permit(
      :case_id,
      :id_tn,
      :user_tn,
      :fio,
      :dept,
      :email,
      :phone,
      :mobile,
      :desc,
      :without_service,
      :without_item,
      :service_id,
      :item_id,
      :invent_num,
      :rating,
      additional: [:comment],
      files: [:filename, :file]
    )
  end
end
