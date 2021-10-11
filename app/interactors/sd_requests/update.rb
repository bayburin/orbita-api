module SdRequests
  # Создает форму по существующей заявке и обновляет запись в базе в соответствии с полученными параметрами.
  class Update
    include Interactor::Organizer

    organize ValidateForm, Save, NotifyOnUpdate, Astraea::UpdateSdRequest
  end
end
