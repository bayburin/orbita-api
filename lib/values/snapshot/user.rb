module Snapshot
  class User < Dry::Struct
    include ActiveModel::Serialization

    attribute :id_tn, Types::Integer.optional
    attribute :tn, Types::Integer.optional
    attribute :fio, Types::Fio.optional
    attribute :dept, Types::Integer.optional
    attribute :user_attrs, Types::Hash.optional.default({}.freeze)
    attribute :domain_user, Types::String.optional
  end
end
