module Events
  # Класс-обработчик события дообавления файла. Класс сохраняет полученные файлы и
  # логирует событие в системе.
  class AddFilesEvent
    include Interactor::Organizer
    include Requirements

    organize FindOrCreateWork, SaveFiles
  end
end
