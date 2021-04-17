# Адаптер для преобразования заявки из Astraea в Орбиту.
class AstraeaAdapter
  include ActiveModel::Serializers::JSON

  attr_reader :works

  def initialize(kase, current_user)
    @kase = kase
    @current_user = current_user

    load_ticket if @kase.ticket_id
    build_works if @kase.users.any?
  end

  def id
    @kase.case_id
  end

  def service_id
    @ticket&.service&.id
  end

  def service_name
    @ticket&.service&.name
  end

  def ticket_identity
    @ticket&.identity
  end

  def ticket_name
    @ticket&.name
  end

  def description
    @kase.desc
  end

  def priority
    @kase.severity
  end

  def finished_at_plan
    Time.zone.at(@kase.time)
  end

  def source_snapshot
    snapshot = SourceSnapshotBuilder.build(
      svt_item_id: @kase.item_id,
      invent_num: @kase.host_id,
      id_tn: @kase.id_tn
    )
    snapshot.user_attrs = { phone: @kase.phone } if @kase.phone
    snapshot
  end

  def comments
    @kase.messages.filter_map { |message| Comment.new(message: message[:info]) if message[:type] == 'comment' }
  end

  protected

  def load_ticket
    response = ServiceDesk::Api.ticket(@kase.ticket_id)

    if response.success?
      @ticket = ServiceDesk::Ticket.new(response.body)
    else
      raise 'Не удалось загрузить данные по заявке'
    end
  end

  def build_works
    @works = @kase.users.group_by(&:group_id).map do |group_id, users|
      WorkBuilder.build(group_id: group_id).tap do |work|
        work.workers.build(*(users.map { |u| { user_id: u.id } }))
      end
      # { group_id: group_id, workers: users.map { |u| { user_id: u.id } } }
    end

    build_workflow unless workflow.empty?
  end

  def build_workflow
    # current_work = works.find { |work| work[:group_id] == @current_user.group_id }
    current_work = works.find { |work| work.group_id == @current_user.group_id }

    if current_work
      # current_work[:workflows] = [{ message: workflow }]
      current_work.workflows.build(message: workflow)
    else
      # works.push(group_id: @current_user.group_id, workers: [{ user_id: @current_user.id }], workflows: [{ message: workflow }])
      work = WorkBuilder.build(group_id: @current_user.group_id)
      work.workers.build(user_id: @current_user.id)
      work.workflows.build(message: workflow)
      works << work
    end
  end

  def workflow
    analysis = @kase.messages.find { |message| message[:type] == 'analysis' }
    measure = @kase.messages.find { |message| message[:type] == 'measure' }
    workflow = ''
    workflow += "Анализ: #{analysis[:info]}; " if analysis
    workflow += "Меры: #{measure[:info]}" if measure
    workflow
  end
end
