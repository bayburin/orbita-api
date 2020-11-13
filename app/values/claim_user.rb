class ClaimUser
  include ActiveModel::Serialization
  include Virtus.model

  values do
    attribute :id_tn, Integer
    attribute :tn, Integer
    attribute :fio, String
    attribute :dept, Integer
    attribute :user_details, Hash
  end
end
