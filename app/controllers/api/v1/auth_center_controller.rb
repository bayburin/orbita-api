class Api::V1::AuthCenterController < Api::V1::BaseController
  def show_host
    # Подумать, возможно использовать класс HostInfoLoader
    auth_center_response = AuthCenter::Api.host_info(current_user.auth_center_token.access_token, params[:id], params[:idfield])
    body = auth_center_response.body.is_a?(Array) ? {} : auth_center_response.body

    render json: body, status: auth_center_response.status
  end

  def show_user_hosts
    auth_center_response = AuthCenter::Api.host_list(current_user.auth_center_token.access_token, params[:tn])

    render json: { hosts: auth_center_response.body }, status: auth_center_response.status
  end
end
