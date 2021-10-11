module SdRequests
  class UpdateChannel < ApplicationCable::Channel
    def subscribed
      stream_from 'sd_requests::update'
    end
  end
end
