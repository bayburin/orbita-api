module Comments
  # Создает комментарий
  class Create
    include Interactor::Organizer

    organize Save, NotifyOnCreate, Astraea::AddComment
  end
end
