module Snapshot
  class HostSerializer < ActiveModel::Serializer
    attributes :dns, :source_ip, :destination_ip, :mac, :invent_num, :location, :os, :netbios
  end
end
