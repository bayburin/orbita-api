module Comments
  # Создает комментарий
  class Create
    include Interactor::Organizer

    organize Save, Astraea::AddComment
  end
end
