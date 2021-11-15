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
    sd_request = SdRequest
                   .where(id: params[:id])
                   .includes(:source_snapshot, :parameter, :comments, :attachments, works: [:workers, :histories, :workflows])
                   .first

    if sd_request
      render(
        json: sd_request,
        include: ['*', 'works.histories', 'works.workers', 'works.workflows'],
      )
    else
      render json: { sd_request: nil }, status: :not_found
    end
  end

  def create
    create = SdRequests::Create.call(
      current_user: current_user,
      form: SdRequests::CreateForm.new(SdRequest.new),
      params: sd_request_params,
      new_files: params[:new_attachments] || []
    )

    if create.success?
      render(
        json: create.sd_request,
        include: ['*', 'works.histories', 'works.workers', 'works.workflows']
      )
    else
      render json: create.error, status: :bad_request
    end
  end

  def update
    sd_request = SdRequest
                   .includes(
                     :source_snapshot,
                     :parameter,
                     :attachments,
                     works: [:group, :histories, workflows: :sender, workers: :user]
                    )
                   .find(params[:id])
    update = SdRequests::Update.call(
      current_user: current_user,
      form: SdRequests::UpdateForm.new(sd_request),
      params: sd_request_params,
      new_files: params[:new_attachments] || []
    )

    if update.success?
      render(
        json: update.sd_request,
        include: ['*', 'works.histories', 'works.workers', 'works.workflows']
      )
    else
      render json: update.error, status: :bad_request
    end
  end

  protected

  def sd_request_params
    ActionController::Parameters.new(JSON.parse(params[:sd_request])).permit(
      :id,
      :service_id,
      :service_name,
      :ticket_identity,
      :ticket_name,
      :description,
      :status,
      :priority,
      :finished_at_plan,
      :sla,
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
        :barcode,
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
        _destroy
      ]
    )
  end
end
