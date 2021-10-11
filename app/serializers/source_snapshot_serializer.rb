class SourceSnapshotSerializer < ActiveModel::Serializer
  attributes :id, :svt_item_id, :barcode
  attributes :id_tn, :tn, :fio, :dept, :user_attrs, :domain_user
  attributes :dns, :source_ip, :destination_ip, :mac, :invent_num, :host_location, :os, :netbios
end
