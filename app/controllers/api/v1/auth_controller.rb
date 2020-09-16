class Api::V1::AuthController < Api::V1::BaseController
  def token
    result = Auth::Authorize.call(code: params[:code])

    if result.success?
      render json: { token: result.jwt }
    else
      render json: { message: result.message }, status: :unauthorized
    end
  end

  def revoke
    # TODO: Необходимо отозвать токен
  end
end