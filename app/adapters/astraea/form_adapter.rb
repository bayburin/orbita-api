module Astraea
  # Адаптер для преобразования заявки из Орбиты в вид, необходимый для системы Astraea.
  # form - объект формы
  # current_user - текущий пользователь
  # type - тип заявки (new - новая, update - существующая)
  class FormAdapter
    include ActiveModel::Serializers::JSON

    def initialize(form, current_user, type = 'new')
      @form = form
      @current_user = current_user
      @state = type == 'update' ? EditFormState.new(form) : NewFormState.new(form)
    end

    # ID кейса
    def case_id
      @form.integration_id
    end

    # Табельный работника, который выполнил некоторое действие
    def user_id
      @current_user.tn
    end

    # Табельный пользователя, подавшего заявку
    def user_tn
      @state.user_tn
    end

    # Телефон пользователя, подавшего заявку
    def phone
      @state.phone
    end

    # Инвентарный номер
    def host_id
      @state.host_id
    end

    # Штрих-код
    def barcode
      @state.barcode
    end

    # Описание заявки
    def desc
      @state.desc
    end

    # Анализ
    def analysis
      result = nil
      @form.works.find { |work| result = work.workflows.find { |workflow| !workflow.id } }
      result&.message
    end

    # Дата контроля
    def rem_date
      Time.parse(@form.finished_at_plan.to_s)
    end

    # Час контроля
    def rem_hour
      rem_date.hour
    end

    # Минут контроля
    def rem_min
      rem_date.min
    end

    # Критичность
    def severity
      @form.priority
    end

    # Актуальный список исполнителей
    def users
      ids = @form.works.flat_map { |work| work.workers.map { |worker| worker.user_id } }
      ids.any? ? User.where(id: ids).pluck(:tn) : []
    end
  end
end
