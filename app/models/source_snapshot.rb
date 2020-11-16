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
end
