class Events::Api::V1::SdRequestsController < Events::Api::V1::BaseController
  def create
    render json: { message: 'ok', user: current_user }
  end
end
