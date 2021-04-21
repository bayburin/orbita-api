module Guest
  module Astraea
    # Создает форму заявки из системы Astraea и сохраняет в базе.
    class Update
      include Interactor::Organizer

      organize ::SdRequests::ValidateForm, ::SdRequests::Save
    end
  end
end
