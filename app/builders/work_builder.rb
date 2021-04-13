# Позволяет построить объект работы для объекта работы Work.
class WorkBuilder < BaseBuilder
  def initialize(params = {})
    @model = Work.new(params)

    super()
  end
end
