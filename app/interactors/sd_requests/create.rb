module SdRequests
  # Создает форму вопроса и сохраняет в базе.
  class Create
    include Interactor::Organizer

    organize ValidateForm, Save
  end
end
