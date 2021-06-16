class FindSdRequestsQuery < SdRequestsQuery
  def call(params = {})
    filters = JSON.parse(params[:filters])

    @scope = scope.by_id(:desc)
    @scope = filter_by_id(filters['id'])
    @scope = filter_by_created_at(filters['created_at'])
    @scope = filter_by_status(filters['status'])
    @scope = filter_by_service_id(filters['service_id'])
    @scope = filter_by_ticket_identity(filters['ticket_identity'])
    @scope = filter_by_description(filters['description'])
    @scope = filter_by_priority(filters['priority'])
    @scope = filter_by_users(filters['users'])
    @scope = paginate(params[:page], params[:per_page])
  end

  private

  def paginate(page = 0, per_page = 25)
    scope.page(page).per(per_page)
  end

  def filter_by_id(id)
    id.present? ? scope.where(id: id) : scope
  end

  def filter_by_created_at(date)
    date.present? ? scope.where('DATE(created_at) = ?', Date.parse(date)) : scope
  end

  def filter_by_status(status)
    status.present? ? scope.where(status: status) : scope
  end

  def filter_by_service_id(service_id)
    service_id.present? ? scope.where(service_id: service_id) : scope
  end

  def filter_by_ticket_identity(ticket_identity)
    ticket_identity.present? ? scope.where(ticket_identity: ticket_identity) : scope
  end

  def filter_by_description(desc)
    desc.present? ? scope.where('description LIKE ?', "%#{desc}%") : scope
  end

  def filter_by_priority(priority)
    priority.present? ? scope.where(priority: priority) : scope
  end

  def filter_by_users(user_ids)
    if user_ids&.any?
      @scope = scope.joins(works: :workers).group(:id)
      user_ids.each { |user_id| @scope = scope.having('SUM(workers.user_id = ?) > 0', user_id) }
    end

    scope
  end
end
