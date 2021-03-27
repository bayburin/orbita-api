class Api::V1::EmployeesController < Api::V1::BaseController
  def index
    data = Employees::Loader.new(:by_any).load(field: params[:key], term: params[:value])

    if data
      render json: data['data']
    else
      render json: { message: 'НСИ не доступен' }, status: :service_unavailable
    end
  end
end
