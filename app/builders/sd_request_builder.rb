# Позволяет построить объект заявки SdRequest.
class SdRequestBuilder < BaseBuilder
  def initialize(params = {})
    @model = SdRequest.new(params)

    super()
  end

  delegate :ticket=, to: :model

  # Создает объект Runtime
  def set_runtime(finished_at_plan, finished_at)
    model.runtime = Runtime.new(finished_at_plan: finished_at_plan, finished_at: finished_at)
  end

  # Добавляет "работу" к заявке.
  def add_work(work)
    model.works << work
  end

  # Создает работы по списку ответственных.
  # users - массив объектов вида { tn: 123 }
  def build_works_by_responsible_users(users)
    user_groups = User.where(tn: users.map { |u| u[:tn] }).group_by(&:group_id)

    user_groups.each do |group_id, users|
      work = model.works.build(group_id: group_id)
      work.users = users
    end
  end
end
