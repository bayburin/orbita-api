module Histories
  # Класс позволяет обрабатывать историю изменений по заявке в рамках текущего запроса.
  class Storage
    attr_reader :histories
    attr_accessor :work, :user

    def initialize(user, work = nil)
      @histories = []
      @user = user
      @work = work
      @tmp = { add_workers: [], del_workers: [], add_files: [], del_files: [] }
    end

    # Добавляет payload во временное хранилище данных.
    # Во время сохранения payload одного типа будут объеденины в соответствующий объект History.
    # type - тип хранилища (add_workers, del_workers)
    def add_to_combine(type, payload)
      @tmp[type] << payload
    end

    # Добавляет полученную историю в список, который будет сохранен. Каждый полученный объект - это отдельная запись в БД.
    def add(history)
      histories << history
    end

    def save!
      processing_workers

      History.transaction do
        histories.sort_by!(&:order).each do |h|
          h.work = work
          h.user = user
          h.user_info = user.as_json(only: [:id_tn, :tn, :fio, :login, :work_tel, :email])
          h.save!
        end
      end
    end

    protected

    def processing_workers
      add(Histories::AddWorkerType.new(workers: users(@tmp[:add_workers])).build) if @tmp[:add_workers].any?
      add(Histories::DelWorkerType.new(workers: users(@tmp[:del_workers])).build) if @tmp[:del_workers].any?
      add(Histories::AddFilesType.new(files: files(@tmp[:add_files])).build) if @tmp[:add_files].any?
      add(Histories::DelFilesType.new(files: files(@tmp[:del_files])).build) if @tmp[:del_files].any?
    end

    def users(ids)
      User.where(id: ids).map(&:fio_initials).join(', ')
    end

    def files(filenames)
      filenames.join(', ')
    end
  end
end
