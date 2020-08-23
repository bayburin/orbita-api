class UserSerializer < ActiveModel::Serializer
  attributes :id, :role_id, :tn, :id_tn, :fio, :work_tel, :mobile_tel, :email, :is_vacation
end
