# Позволяет построить объект работы для заявки Work.
class WorkBuilder < ApplicationBuilder
  def initialize(params = {})
    @model = Work.new(params)
  end

  def title=(title)
    model.title = title
  end

  def status=(status)
    model.status = status
  end

  def attrs=(attrs)
    model.attrs = attrs
  end
end
