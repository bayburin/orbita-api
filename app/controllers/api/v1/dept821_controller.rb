class Api::V1::Dept821Controller < Api::V1::BaseController
  def create
    create = Applications::Place821.call(params: application_params)

    if create.success?
      render json: create.application
    else
      render json: create.errors, status: :unprocessable_entity
    end
  end

  protected

  def application_params
    params.require(:dept821).permit(:id_tn, attrs: {})
  end
end
