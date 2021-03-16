class EmployeeContact
  include Virtus.model

  attribute :id, Integer # id_tn
  attribute :position, String # Расположение
  attribute :phone, Array[String]
  attribute :email, Array[String]
  attribute :login, String # AD Login
end
