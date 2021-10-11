module Astraea
  class CommentAdapterSerializer < ActiveModel::Serializer
    attributes :user_id, :case_id, :comment

    def user_id
      object.sender.tn
    end

    def case_id
      object.claim_id
    end

    def comment
      object.message
    end
  end
end
