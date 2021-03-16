# Класс, описывающий объект из БД НСИ
class Employee
  include Virtus.model

  attribute :lastName, Fio
  attribute :firstName, Fio
  attribute :middleName, Fio
  attribute :id, Integer
  attribute :dateOfBirth, Date
  attribute :sex, String
  attribute :employeePositions, Array[EmployeePosition]
  attribute :employeeContact, EmployeeContact

  def fio
    "#{lastName} #{firstName} #{middleName}"
  end
end
