module ServiceDesk
  module Lk
    # Создает форму заявки на выдачу ВТ и сохраняет в базе.
    class CreateSvtItemRequest
      include Interactor::Organizer

      organize BuildSvtItemForm, ::SdRequests::ValidateForm, ::SdRequests::Save, ::SdRequests::BroadcastOnCreate
    end
  end
end
