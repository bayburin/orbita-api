class ServiceDesk::Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action { warden.authenticate! :api, scope: :user }

  def welcome
    render json: { message: 'service-desk/v1' }
  end
end
