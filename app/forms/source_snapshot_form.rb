# Описывает форму, которая создает объект SourceSnapshot
class SourceSnapshotForm < Reform::Form
  property :id
  property :claim_id
  property :id_tn
  property :tn
  property :fio
  property :dept
  property :user_attrs
  property :dns
  property :domain_user
  property :source_ip
  property :destination_ip
  property :mac
  property :invent_num
  property :svt_item_id
  property :os
  property :netbios
end
