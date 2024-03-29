class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: :token

  def token
    result = Users::Authorize.call(code: params[:code])

    if result.success?
      render json: { token: result.jwt }
    else
      render json: { message: result.message }, status: :bad_request
    end
  end

  def revoke
    # TODO: Необходимо отозвать токен
  end
end
