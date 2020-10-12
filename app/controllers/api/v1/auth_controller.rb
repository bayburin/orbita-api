class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: :token

  def token
    result = Auth::Authorize.call(code: auth_params[:code])

    if result.success?
      render json: { token: result.jwt }
    else
      render json: { message: result.message }, status: :bad_request
    end
  end

  def revoke
    # TODO: Необходимо отозвать токен
  end

  protected

  def auth_params
    params.require(:auth).permit(:code)
  end
end
