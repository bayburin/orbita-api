module SdRequests
  # Синхронизирует данные с системой Astraea.
  class SyncWithAstraea
    include Interactor

    delegate :form, :current_user, :new_files, to: :context

    def call
      form_data = AstraeaFormAdapterSerializer.new(AstraeaFormAdapter.new(form, current_user)).as_json

      astraea_response = Astraea::Api.create_sd_request(form_data, new_files)
      if astraea_response.success?
        form.model.update(
          integration_id: JSON.parse(astraea_response.body)['case_id'],
          application_id: Doorkeeper::Application.find_by(name: 'Astraea').id
        )
      end
    end
  end
end
