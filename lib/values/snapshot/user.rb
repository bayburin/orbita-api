module Snapshot
  class User
    include ActiveModel::Serialization
    include Virtus.value_object

    values do
      attribute :id_tn, Integer
      attribute :tn, Integer
      attribute :fio, Fio
      attribute :dept, Integer
      attribute :user_attrs, Hash, default: {}
      attribute :domain_user, String
    end
  end
end
