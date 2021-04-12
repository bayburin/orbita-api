module Snapshot
  class Host < Dry::Struct
    include ActiveModel::Serialization
    transform_keys(&:to_sym)

    attribute? :dns, Types::String.optional
    attribute? :source_ip, Types::String.optional
    attribute? :destination_ip, Types::String.optional
    attribute? :mac, Types::String.optional
    attribute? :invent_num, Types::String.optional
    attribute? :os, Types::String.optional
    attribute? :netbios, Types::String.optional
  end
end
