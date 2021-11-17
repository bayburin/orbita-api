module ServiceDesk
  module Api
    module V1
      class UserMessageSerializer < ActiveModel::Serializer
        attributes :id, :claim_id, :type, :message, :accept_value, :accept_comment, :created_at
      end
    end
  end
end
