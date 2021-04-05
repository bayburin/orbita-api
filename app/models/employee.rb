# Класс, описывающий объект из БД НСИ
class Employee < Dry::Struct
  attribute :lastName, Types::Fio
  attribute :firstName, Types::Fio
  attribute :middleName, Types::Fio
  attribute :id, Types::Integer # id_tn
  attribute :dateOfBirth, Types::Date.constructor(&:to_date)
  attribute :sex, Types::String.enum('М', 'Ж')
  attribute :employeePositions, Types::Array do
    attribute :employeeId, Types::Integer # id_tn
    attribute :personnelNo, Types::Integer # tn
    attribute :departmentForAccounting, Types::Integer # отдел
  end
  attribute :employeeContact do
    attribute :id, Types::Integer # id_tn
    attribute :position, Types::String # Расположение
    attribute :phone, Types::Array.of(Types::String)
    attribute :email, Types::Array.of(Types::Email)
    attribute :login, Types::String # AD Login
  end

  def fio
    "#{lastName} #{firstName} #{middleName}"
  end
end
