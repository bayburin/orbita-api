module SdRequests
  # Создает объект заявки 821 отдела и сохраняет ее в базе.
  class Place821
    include Interactor::Organizer

    organize Build821, Create
  end
end
