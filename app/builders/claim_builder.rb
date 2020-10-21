# Позволяет построить объект заявки.
class ClaimBuilder
  attr_reader :claim

  def self.build
    builder = new
    yield(builder) if block_given?
    builder.claim
  end

  def initialize
    @claim = Claim.new
  end

  def set_service(service_id, service_name)
    claim.service = Service.new(id: service_id, name: service_name)
  end

  def set_app_template(app_template_id, app_template_name)
    claim.app_template = AppTemplate.new(id: app_template_id, name: app_template_name)
  end

  def service_id=(service_id)
    claim.service_id = service_id
  end

  def service_name=(service_name)
    claim.service_name = service_name
  end

  def app_template_id=(app_template_id)
    claim.app_template_id = app_template_id
  end

  def app_template_name=(app_template_name)
    claim.app_template_name = app_template_name
  end

  def status=(status)
    claim.status = status
  end

  # FIXME: Исправить метод, чтобы сохранять все данные, а не только tn
  def user_credentials=(tn)
    claim.tn = tn
  end

  def attrs=(attrs)
    claim.attrs = attrs
  end

  def rating=(rating)
    claim.rating = rating
  end

  def set_runtime(finished_at_plan, finished_at)
    claim.runtime = Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at)
  end

  def add_work(work)
    claim.works << work
  end
end