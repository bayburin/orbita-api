class Api::V1::SdRequestsController < Api::V1::BaseController
  def create
    create_form = SdRequestForm.new(SdRequest.new)

    if create_form.validate(sd_request_params) && create_form.save
      render json: create_form.model, status: 200
    else
      render json: { error: create_form.errors }, status: 422
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
      ]
    )
  end
end
