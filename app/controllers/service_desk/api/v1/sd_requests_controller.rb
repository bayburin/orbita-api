class ServiceDesk::Api::V1::SdRequestsController < ServiceDesk::Api::V1::BaseController
  def create
    render json: { params: sd_request_params }
  end

  protected

  def sd_request_params
    ActionController::Parameters.new(JSON.parse(params[:sd_request])).permit(
      :service_id,
      :service_name,
      :ticket_identity,
      :ticket_name,
      :description,
      :priority,
      :finished_at_plan,
      :sla,
      source_snapshot: [
        :id_tn,
        :tn,
        :fio,
        :dept,
        :svt_item_id,
        :barcode,
        :invent_num,
        { user_attrs: {} }
      ],
      comments: [:id, :message],
    )
  end
end
