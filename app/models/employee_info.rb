# Класс, описывающий объект из БД НСИ
class EmployeeInfo < Dry::Struct
  transform_keys(&:to_sym)

  attribute :lastName, Types::Fio
  attribute :firstName, Types::Fio
  attribute :middleName, Types::Fio
  attribute :id, Types::Integer # id_tn
  attribute :dateOfBirth?, Types::Date.constructor(&:to_date)
  attribute :sex?, Types::String.enum('М', 'Ж')
  attribute? :code, Types::Integer # tn
  attribute? :employeePositions, Types::Array do
    attribute :employeeId, Types::Integer # id_tn
    attribute :personnelNo, Types::Integer # tn
    attribute :departmentForAccounting, Types::Integer # отдел
  end
  attribute? :employeeContact do
    attribute :id, Types::Integer # id_tn
    attribute? :position, Types::String # Расположение
    attribute? :phone, Types::Array.of(Types::String)
    attribute? :email, Types::Array.of(Types::Email)
    attribute? :login, Types::String # AD Login
  end
  attribute? :company do
    attribute :code, Types::Integer # отдел
    attribute :shortName, Types::String
    attribute :name, Types::String
  end

  def fio
    "#{lastName} #{firstName} #{middleName}"
  end

  def first_phone
    employeeContact.phone&.first
  end

  def first_email
    employeeContact.email&.first
  end

  def tn
    employeePositions&.first&.personnelNo || code
  end

  def dept
    employeePositions&.first&.departmentForAccounting || company.code
  end
end
