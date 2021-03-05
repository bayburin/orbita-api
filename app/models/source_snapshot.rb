class SourceSnapshot < ApplicationRecord
  belongs_to :claim

  def claim_user
    ClaimUser.new(
      id_tn: id_tn,
      tn: tn,
      fio: fio,
      dept: dept,
      user_attrs: user_attrs
    )
  end

  def claim_user=(claim_user)
    self.id_tn = claim_user.id_tn
    self.tn = claim_user.tn
    self.fio = claim_user.fio
    self.dept = claim_user.dept
    self.user_attrs = claim_user.user_attrs
  end

  def host
    Host.new(
      dns: dns,
      source_ip: source_ip,
      destination_ip: destination_ip,
      mac: mac,
      invent_num: invent_num,
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
    self.os = host.os
    self.netbios = host.netbios
  end
end
