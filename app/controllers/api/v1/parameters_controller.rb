class Api::V1::ParametersController < Api::V1::BaseController
  def index
    parameters = Parameter.where(claim_id: params[:sd_request_id])

    render json: parameters, each_serializer: ParameterSerializer
  end
end
