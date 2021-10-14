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

    def case_id
      @form.integration_id
    end

    def user_id
      @current_user.tn
    end

    def phone
      @state.phone
    end

    def host_id
      @state.host_id
    end

    def barcode
      @state.barcode
    end

    def desc
      @state.desc
    end

    def analysis
      result = nil
      @form.works.find { |work| result = work.workflows.find { |workflow| !workflow.id } }
      result&.message
    end

    def rem_date
      Time.parse(@form.finished_at_plan.to_s)
    end

    def rem_hour
      rem_date.hour
    end

    def rem_min
      rem_date.min
    end

    def severity
      @form.priority
    end

    def users
      ids = @form.works.flat_map { |work| work.workers.map { |worker| worker.user_id } }
      ids.any? ? User.where(id: ids).pluck(:tn) : []
    end
  end
end
