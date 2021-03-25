module SdRequests
  # Создает форму по существующей заявке и обновляет запись в базе в соответствии с полученными параметрами.
  class Update
    include Interactor::Organizer

    organize ValidateUpdateForm, SaveUpdateForm
  end
end
