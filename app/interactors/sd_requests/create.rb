module SdRequests
  # Создает форму заявки и сохраняет в базе.
  class Create
    include Interactor::Organizer

    organize ValidateForm, Save, NotifyOnCreate, Astraea::CreateSdRequest
  end
end
