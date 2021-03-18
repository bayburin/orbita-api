module SdRequests
  # Создает объект заявки для 821 отдела.
  class Build821
    include Interactor

    delegate :params, :sd_request, to: :context

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.sd_request = SdRequestBuilder.build(params) do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_ticket(nil, 'Заявка на размножение КД')
      end

      params.merge!(source_snapshot: { id_tn: params[:id_tn] })
    end
  end
end
