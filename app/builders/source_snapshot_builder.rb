# Позволяет построить объект работы для объекта SourceSnapshot.
class SourceSnapshotBuilder < BaseBuilder
  def initialize(params = {})
    @model = SourceSnapshot.new(params)

    super()
  end

  # Загружает данные по пользователю из БД НСИ.
  def user_credentials=(id_tn)
    employee_info = Employees::Loader.new(:load).load(id_tn)
    attrs = { id_tn: id_tn }

    if employee_info
      employee = EmployeeInfo.new(employee_info)
      attrs.merge!(
        tn: employee.employeePositions.first.personnelNo,
        fio: employee.fio,
        dept: employee.employeePositions.first.departmentForAccounting,
        domain_user: employee.employeeContact.login
      )
    end

    model.user = Snapshot::User.new(attrs)
  end

  # Загружает данные по хосту из Netadmin.
  def host_credentials=(invent_num)
    data = AuthCenter::HostInfoLoader.new.load(invent_num)
    attrs = data.any? ? { dns: data['name'], source_ip: data['ip'], mac: data['mac'], os: data['os'], location: data['room'] } : {}
    model.host = Snapshot::Host.new(attrs)
  end
end
