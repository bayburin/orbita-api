# Позволяет построить объект работы для объекта SourceSnapshot.
class SourceSnapshotBuilder < BaseBuilder
  def initialize(params = {})
    @model = SourceSnapshot.new(params)
  end

  def user_credentials=(id_tn)
    user_info = Employees::Employee.new(:load).load(id_tn)
    attrs = { id_tn: id_tn }

    if user_info
      data = user_info['employeePositions'][0]

      attrs[:tn] = data['personnelNo']
      attrs[:fio] = "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}"
      attrs[:dept] = data['departmentForAccounting']
    end

    model.claim_user = ClaimUser.new(attrs)
  end
end
