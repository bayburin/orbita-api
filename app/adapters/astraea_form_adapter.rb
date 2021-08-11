# Адаптер для преобразования заявки из Орбиты в вид, необходимый для системы Astraea.
class AstraeaFormAdapter
  include ActiveModel::Serializers::JSON

  def initialize(form, current_user)
    @form = form
    @current_user = current_user
  end

  def case_id
    @form.integration_id
  end

  def user_id
    @form.source_snapshot.tn
  end

  def phone
    @form.source_snapshot.user_attrs[:phone]
  end

  def host_id
    @form.source_snapshot.invent_num
  end

  def barcode
    @form.source_snapshot.barcode
  end

  def desc
    @form.description
  end

  def analysis
    @form.works.find { |work| work.workflows.find { |workflow| !workflow.id } }
  end

  def rem_date
    @form.finished_at_plan
  end

  def rem_hour
    @form.finished_at_plan.hour
  end

  def rem_min
    @form.finished_at_plan.min
  end

  def severity
    @form.priority
  end

  def users
    ids = @form.works.map { |work| work.workers.map { |worker| worker.user_id } }.flatten
    User.where(id: ids).pluck(:tn)
  end
end
