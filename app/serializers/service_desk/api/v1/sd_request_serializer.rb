module ServiceDesk
  module Api
    module V1
      class SdRequestSerializer < ActiveModel::Serializer
        attributes :id, :service_id, :ticket_identity, :service_name, :ticket_name, :description, :status, :rating, :runtime

        has_many :attachments
        has_many :user_messages

        def attachments
          object.attachments.select(&:is_public)
        end

        def user_messages
          object.works.map do |work|
            work.messages.select { |m| m.type == 'ToUserAccept' || m.type == 'ToUserMessage' }
          end.flatten
        end

        def runtime
          RuntimeSerializer.new(object.runtime).as_json
        end
      end
    end
  end
end
