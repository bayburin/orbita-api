class Api::V1::ClaimsController < Api::V1::BaseController
  def index
    render json: Claim.all.includes(works: [:group, { histories: :event_type }]), include: 'works.histories.event_type,works.group,works.workers'
  end
end
