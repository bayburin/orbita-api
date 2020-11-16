# Класс заявки от пользователя
class Application < Claim
  enum status: { opened: 1, at_work: 2, canceled: 3, approved: 4, reopened: 5 }, _suffix: true

  def service
    Service.new(id: service_id, name: service_name)
  end

  def service=(service)
    self.service_id = service.id
    self.service_name = service.name
  end

  def app_template
    AppTemplate.new(id: app_template_id, name: app_template_name)
  end

  def app_template=(app_template)
    self.app_template_id = app_template.id
    self.app_template_name = app_template.name
  end
end
