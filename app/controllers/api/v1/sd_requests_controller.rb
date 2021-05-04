class Api::V1::SdRequestsController < Api::V1::BaseController
  def index
    render(
      json: SdRequest.includes(works: [:group, { workers: :user, histories: :event_type }]).order(id: :desc).limit(25),
      include: ['works.histories.event_type', 'works.group', 'works.workers.user.fio']
    )
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
