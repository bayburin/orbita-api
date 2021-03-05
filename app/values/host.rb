class Host
  include ActiveModel::Serialization
  include Virtus.model

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
