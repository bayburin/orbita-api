module Guest
  module Astraea
    # Создает форму заявки из системы Astraea и сохраняет в базе.
    class Create
      include Interactor::Organizer

      organize ::SdRequests::ValidateForm, ::SdRequests::Save, ::SdRequests::NotifyOnCreate
    end
  end
end
