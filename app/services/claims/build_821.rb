module Claims
  # Создает объект заявки для 821 отдела.
  class Build821
    include Interactor

    delegate :params, to: :context

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.claim = ClaimBuilder.build(params) do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_app_template(nil, 'Заявка на размножение КД')
        cl.user_credentials = params[:id_tn]
      end
    end
  end
end
