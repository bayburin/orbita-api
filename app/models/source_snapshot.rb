class SourceSnapshot < ApplicationRecord
  belongs_to :claim

  def user
    Snapshot::User.new(
      id_tn: id_tn,
      tn: tn,
      fio: fio,
      dept: dept,
      user_attrs: user_attrs,
      domain_user: domain_user
    )
  end

  def user=(user)
    self.id_tn = user.id_tn
    self.tn = user.tn
    self.fio = user.fio
    self.dept = user.dept
    self.user_attrs = user.user_attrs
    self.domain_user = user.domain_user
  end

  def host
    Snapshot::Host.new(
      dns: dns,
      source_ip: source_ip,
      destination_ip: destination_ip,
      mac: mac,
      invent_num: invent_num,
      svt_item_id: svt_item_id,
      barcode: barcode,
      location: host_location,
      os: os,
      netbios: netbios
    )
  end

  def host=(host)
    self.dns = host.dns
    self.source_ip = host.source_ip
    self.destination_ip = host.destination_ip
    self.mac = host.mac
    self.invent_num = host.invent_num
    self.host_location = host.location
    self.os = host.os
    self.netbios = host.netbios
  end
end
