# Адаптер для преобразования заявки из Astraea в Орбиту.
class AstraeaAdapter
  include ActiveModel::Serializers::JSON

  STATUSES = {
    'Не обработано': :opened,
    'В работе': :at_work,
    'Выполнено': :done,
    'Отклонено': :canceled
  }.freeze

  attr_reader :works

  def initialize(kase, current_user, sd_request = nil)
    @kase = kase
    @current_user = current_user
    @sd_request = sd_request

    load_ticket if @kase.ticket_id
    build_works if @kase.users.any?
  end

  def integration_id
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

  def status
    STATUSES[@kase.status_id.to_sym]
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
    build_workflow_message

    if @sd_request
      process_existing_works
    else
      build_new_works
    end

    build_workflow unless @workflow_message.to_s.empty?
  end

  def process_existing_works
    removed_users = @sd_request.users - @kase.users - [@current_user]
    new_users = @kase.users - [@current_user] - @sd_request.users

    @works = @sd_request.works.map do |work|
      work.workers = work.workers.to_a
      work.workers.select { |w| removed_users.uniq.map(&:id).include?(w.user_id) }.each { |u| u._destroy = true }
      work
    end
    new_users.group_by(&:group_id).each do |group_id, _users|
      work = works.find { |w| w.group_id == group_id }

      if work
        work.workers.build(new_users.uniq.filter_map { |u| { user_id: u.id } if u.group_id == group_id })
      else
        works << WorkBuilder.build(group_id: group_id).tap do |w|
          w.workers.build(new_users.uniq.filter_map { |u| { user_id: u.id } if u.group_id == group_id })
        end
      end
    end
  end

  def build_new_works
    @works = @kase.users.group_by(&:group_id).map do |group_id, users|
      WorkBuilder.build(group_id: group_id).tap do |work|
        work.workers.build(users.uniq.map { |u| { user_id: u.id } })
      end
    end
  end

  def build_workflow
    current_work = works.find { |work| work.group_id == @current_user.group_id }

    if current_work
      current_work.workflows.build(message: @workflow_message)
    else
      work = WorkBuilder.build(group_id: @current_user.group_id)
      work.workers.build(user_id: @current_user.id)
      work.workflows.build(message: @workflow_message)
      works << work
    end
  end

  def build_workflow_message
    analysis = @kase.messages.find { |message| message[:type] == 'analysis' }
    measure = @kase.messages.find { |message| message[:type] == 'measure' }
    @workflow_message = ''
    @workflow_message += "Анализ: #{analysis[:info]}; " if analysis
    @workflow_message += "Меры: #{measure[:info]}" if measure
    @workflow_message
  end
end
