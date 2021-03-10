module SdRequests
  # Создает форму вопроса и сохраняет в базе.
  class Create
    include Interactor::Organizer

    organize Build, Save
  end
end
