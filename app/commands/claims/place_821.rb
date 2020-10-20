# Создает объект заявки 821 отдела и сохраняет ее в базе.
module Claims
  class Place821
    include Interactor::Organizer

    organize Build821, Create
  end
end
