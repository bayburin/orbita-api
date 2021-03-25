class Api::V1::SdRequestsController < Api::V1::BaseController
  def create
    create = SdRequests::Create.call(
      current_user: current_user,
      form: SdRequests::CreateForm.new(SdRequest.new),
      params: sd_request_params
    )

    if create.success?
      render json: create.sd_request, include: ['works.group', 'works.workers.user']
    else
      render json: create.error, status: :bad_request
    end
  end

  def update
    update = SdRequests::Update.call(
      current_user: current_user,
      form: SdRequests::UpdateForm.new(SdRequest.includes(works: [:group, workers: :user]).find(params[:id])),
      params: sd_request_params
    )

    if update.success?
      render json: update.sd_request, include: ['works.group', 'works.workers.user']
    else
      render json: update.error, status: :bad_request
    end
  end

  protected

  def sd_request_params
    params.require(:sd_request).permit(
      :id,
      :service_id,
      :service_name,
      :ticket_identity,
      :ticket_name,
      :description,
      :priority,
      :finished_at_plan,
      attrs: {},
      source_snapshot: [
        :id_tn,
        :svt_item_id,
        :invent_num,
        { user_attrs: {} }
      ],
      works: [
        :id,
        :claim_id,
        :group_id,
        { workers: [:id, :work_id, :user_id, :_destroy] }
      ],
      attachments: %i[
        id
        claim_id
        attachment
      ]
    )
  end
end
