module SdRequests
  class CreateChannel < ApplicationCable::Channel
    def subscribed
      stream_from 'sd_requests::create'
    end
  end
end
