class Api::V1::Dept821Controller < Api::V1::BaseController
  def create
    # TODO: Вынести весь процесс в отдельные команды.
    # TODO: Убрать хардкод при использовании билдера.
    claim = ClaimBuilder.build do |cl|
      cl.set_service(nil, 'Отдел 821')
      cl.set_app_template(nil, 'Заявка на размножение КД')
    end
    claim_form = ClaimForm.new(claim)

    if claim_form.validate(claim_params) && claim_form.save
      render json: claim_form.model
    else
      render json: { error: claim.form.errors }, status: :unprocessable_entity
    end
  end

  protected

  def claim_params
    params.require(:claim).permit(:tn, :attrs)
  end
end
