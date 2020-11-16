# Позволяет построить объект заявки Application.
class ApplicationBuilder < BaseBuilder
  def initialize(params = {})
    @model = Application.new(params)
  end

  def set_service(service_id, service_name)
    model.service = Service.new(id: service_id, name: service_name)
  end

  def set_app_template(app_template_id, app_template_name)
    model.app_template = AppTemplate.new(id: app_template_id, name: app_template_name)
  end

  def service_id=(service_id)
    model.service_id = service_id
  end

  def service_name=(service_name)
    model.service_name = service_name
  end

  def app_template_id=(app_template_id)
    model.app_template_id = app_template_id
  end

  def app_template_name=(app_template_name)
    model.app_template_name = app_template_name
  end

  def status=(status)
    model.status = status
  end

  def attrs=(attrs)
    model.attrs = attrs
  end

  def rating=(rating)
    model.rating = rating
  end

  def set_runtime(finished_at_plan, finished_at)
    model.runtime = Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at)
  end

  def add_work(work)
    model.works << work
  end
end
