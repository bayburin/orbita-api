class Api::V1::UsersController < Api::V1::BaseController
  def index
    render json: User.all.includes(:role, :group)
  end
end
