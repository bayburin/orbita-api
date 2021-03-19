# Позволяет построить объект заявки SdRequest.
class SdRequestBuilder < BaseBuilder
  def initialize(params = {})
    @model = SdRequest.new(params)

    super()
  end

  def set_runtime(finished_at_plan, finished_at)
    model.runtime = Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at)
  end

  def add_work(work)
    model.works << work
  end
end
