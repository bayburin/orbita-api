class EmployeePosition
  include Virtus.model

  attribute :employeeId, Integer # id_tn
  attribute :personnelNo, Integer # tn
  attribute :departmentForAccounting, Integer # отдел
end
