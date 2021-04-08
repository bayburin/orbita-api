class UserSerializer < ActiveModel::Serializer
  attributes :id, :role_id, :group_id, :tn, :id_tn, :fio, :work_tel, :mobile_tel, :email, :is_vacation, :auth_center_token

  belongs_to :role
  belongs_to :group

  def auth_center_token
    AuthCenterTokenSerializer.new(object.auth_center_token).as_json
  end
end
