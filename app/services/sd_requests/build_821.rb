module SdRequests
  # Создает объект заявки для 821 отдела.
  class Build821
    include Interactor

    delegate :params, :sd_request, to: :context

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.sd_request = SdRequestBuilder.build(params) do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_app_template(nil, 'Заявка на размножение КД')
      end
    end
  end
end
