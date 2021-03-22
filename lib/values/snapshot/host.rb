module Snapshot
  class Host
    include ActiveModel::Serialization
    include Virtus.value_object

    values do
      attribute :dns, String
      attribute :domain_user, String
      attribute :source_ip, String
      attribute :destination_ip, String
      attribute :mac, String
      attribute :invent_num, String
      attribute :os, String
      attribute :netbios, String
    end
  end
end
