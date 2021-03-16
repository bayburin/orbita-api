# Позволяет построить объект работы для объекта SourceSnapshot.
class SourceSnapshotBuilder < BaseBuilder
  def initialize(params = {})
    @model = SourceSnapshot.new(params)

    super()
  end

  def user_credentials=(id_tn)
    user_info = Employees::Loader.new(:load).load(id_tn)
    employee = Employee.new(user_info)
    attrs = { id_tn: id_tn }

    if user_info
      attrs.merge!(
        tn: employee.employeePositions.first.personnelNo,
        fio: employee.fio,
        dept: employee.employeePositions.first.departmentForAccounting,
        domain_user: employee.employeeContact.login
      )
    end

    model.claim_user = ClaimUser.new(attrs)
  end

  def set_host_credentials(current_user, invent_num)
    host_info = Api::AuthCenter.host_info(current_user.auth_center_token.access_token, invent_num)
    attrs = {}

    if host_info.success?
      data = host_info.body
      attrs.merge!(dns: data['name'], source_ip: data['ip'], mac: data['mac'], os: data['os'])
    end

    model.host = Host.new(attrs)
  end
end
