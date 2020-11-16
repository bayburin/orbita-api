class ClaimUserSerializer < ActiveModel::Serializer
  attributes :id_tn, :tn, :fio, :dept, :user_attrs
end
