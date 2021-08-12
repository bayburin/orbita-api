class Api::V1::EmployeesController < Api::V1::BaseController
  def index
    search = Employees::Search.call(filters: JSON.parse(params[:filters]))

    if search.success?
      render json: { employees: search.employees }
    else
      render json: { message: 'НСИ не доступен' }, status: :service_unavailable
    end
  end

  def show
    data = Employees::Loader.new(:load).load(params[:id])

    render json: data || {}
  end
end
