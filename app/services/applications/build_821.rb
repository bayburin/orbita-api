module Applications
  # Создает объект заявки для 821 отдела.
  class Build821
    include Interactor

    delegate :params, :application, to: :context

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.application = ApplicationBuilder.build(params) do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_app_template(nil, 'Заявка на размножение КД')
      end
    end
  end
end
