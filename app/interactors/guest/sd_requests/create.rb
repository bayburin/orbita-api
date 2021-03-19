module Guest
  module SdRequests
    # Создает форму вопроса и сохраняет в базе.
    class Create
      include Interactor::Organizer

      organize ServiceDesk::LoadTicketData, ::SdRequests::BuildFromEvent, ::SdRequests::ValidateForm, ::SdRequests::Save
    end
  end
end
