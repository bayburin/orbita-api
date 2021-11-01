module ServiceDesk
  module Lk
    # Создает форму заявки на выдачу ВТ и сохраняет в базе.
    class CreateSvtItemRequest
      include Interactor::Organizer

      organize(
        ServiceDesk::LoadTicketData,
        BuildSvtItemForm,
        AdapteeParams,
        SdRequests::ValidateForm,
        SdRequests::Save,
        SdRequests::BroadcastOnCreate,
        SdRequests::CreateInExternalApp
      )
    end
  end
end
