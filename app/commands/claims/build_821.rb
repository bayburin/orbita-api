# Создает объект заявки для 821 отдела.
module Claims
  class Build821
    include Interactor

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.claim = ClaimBuilder.build do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_app_template(nil, 'Заявка на размножение КД')
      end
    end
  end
end
