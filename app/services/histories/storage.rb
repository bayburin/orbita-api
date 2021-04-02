module Histories
  # Класс позволяет обрабатывать историю изменений по заявке в рамках текущего запроса.
  class Storage
    attr_reader :histories
    attr_accessor :work, :user

    def initialize(user)
      @histories = []
      @user = user
      @tmp = { add_workers: [], del_workers: [] }
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
          h.save!
        end
      end
    end

    protected

    def processing_workers
      add(Histories::AddWorkerType.new(workers: users(@tmp[:add_workers])).build) if @tmp[:add_workers].any?
      add(Histories::DelWorkerType.new(workers: users(@tmp[:del_workers])).build) if @tmp[:del_workers].any?
    end

    def users(ids)
      User.where(id: ids).map(&:fio_initials).join(', ')
    end
  end
end
