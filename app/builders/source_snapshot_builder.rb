# Позволяет построить объект работы для объекта SourceSnapshot.
class SourceSnapshotBuilder < BaseBuilder
  def initialize(params = {})
    @model = SourceSnapshot.new(params)

    super()
  end

  def user_credentials=(id_tn)
    user_info = Employees::Employee.new(:load).load(id_tn)
    attrs = { id_tn: id_tn }

    if user_info
      data = user_info['employeePositions'].first

      attrs.merge!(
        tn: data['personnelNo'],
        fio: "#{user_info['lastName']} #{user_info['firstName']} #{user_info['middleName']}",
        dept: data['departmentForAccounting']
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
