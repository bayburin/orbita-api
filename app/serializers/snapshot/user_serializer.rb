module Snapshot
  class UserSerializer < ActiveModel::Serializer
    attributes :id_tn, :tn, :fio, :dept, :user_attrs
  end
end
