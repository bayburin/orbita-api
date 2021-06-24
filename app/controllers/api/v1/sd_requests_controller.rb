class Api::V1::SdRequestsController < Api::V1::BaseController
  def index
    sd_requests = FindSdRequestsQuery
                    .new(SdRequest.includes(:source_snapshot, :comments, works: [:workers, :histories]))
                    .call(params)

    render(
      json: sd_requests,
      include: ['source_snapshot', 'comments', 'works.histories', 'works.workers'],
      meta: pagination_dict(sd_requests)
    )
  end

  def show
    sd_request = SdRequest.where(id: params[:id]).includes(:source_snapshot, :parameters, :comments, works: [:workers, :histories]).first

    if sd_request
      render(
        json: sd_request,
        include: ['source_snapshot', 'comments', 'parameters', 'works.histories', 'works.workers'],
      )
    else
      render json: { sd_request: nil }, status: 404
    end
  end

  def create
    create = SdRequests::Create.call(
      current_user: current_user,
      form: SdRequests::CreateForm.new(SdRequest.new),
      params: sd_request_params
    )

    if create.success?
      render json: create.sd_request, include: ['*', 'works.workers.user']
    else
      render json: create.error, status: :bad_request
    end
  end

  def update
    sd_request = SdRequest.includes(comments: :sender, works: [:group, workers: :user, workflows: :sender]).find(params[:id])
    update = SdRequests::Update.call(
      current_user: current_user,
      form: SdRequests::UpdateForm.new(sd_request),
      params: sd_request_params
    )

    if update.success?
      render json: update.sd_request, include: ['*', 'works.workers.user']
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
      parameters: [
        :id,
        :claim_id,
        :name,
        :value
      ],
      source_snapshot: [
        :id_tn,
        :tn,
        :fio,
        :dept,
        :svt_item_id,
        :invent_num,
        { user_attrs: {} }
      ],
      works: [
        :id,
        :claim_id,
        :group_id,
        { workflows: [:id, :message] },
        { workers: [:id, :work_id, :user_id, :_destroy] }
      ],
      comments: [:id, :message],
      attachments: %i[
        id
        claim_id
        attachment
      ]
    )
  end
end
