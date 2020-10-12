class Api::V1::ClaimsController < Api::V1::BaseController
  def index
    render json: Claim.all.includes(:works)
  end
end
