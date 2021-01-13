class Api::V1::SdRequestsController < Api::V1::BaseController
  def create
    create = SdRequests::Create.call(params: sd_request_params)

    if create.success?
      render json: create.sd_request
    else
      render json: create.error, status: :unprocessable_entity
    end
  end

  protected

  def sd_request_params
    params.require(:sd_request).permit(
      :id,
      :service_id,
      :service_name,
      :app_template_id,
      :app_template_name,
      :priority,
      :finished_at_plan,
      attrs: {},
      source_snapshot: [
        :id_tn,
        :svt_item_id,
        { user_attrs: {} }
      ],
      works: [
        :id,
        :claim_id,
        :group_id,
        { users: [:id] }
      ],
      attachments: [
        :id,
        :claim_id,
        :attachment
      ]
    )
  end
end
