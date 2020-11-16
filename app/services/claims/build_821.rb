module Claims
  # Создает объект заявки для 821 отдела.
  class Build821
    include Interactor

    delegate :params, :claim, to: :context

    def call
      # TODO: Убрать хардкод при использовании билдера.
      context.claim = ApplicationBuilder.build(params) do |cl|
        cl.set_service(nil, 'Отдел 821')
        cl.set_app_template(nil, 'Заявка на размножение КД')
      end

      # claim.source_snapshot = SourceSnapshotBuilder.build do |ss|
      #   ss.user_credentials = params[:id_tn]
      # end
    end
  end
end
