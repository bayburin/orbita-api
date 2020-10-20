# Позволяет построить объект работы для заявки.
class WorkBuilder
  attr_reader :work

  def self.build
    builder = new
    yield(builder) if block_given?
    builder.work
  end

  def initialize
    @work = Work.new
  end

  def title=(title)
    work.title = title
  end

  def status=(status)
    work.status = status
  end

  def attrs=(attrs)
    work.attrs = attrs
  end
end
