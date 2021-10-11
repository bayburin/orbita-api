class Guest::Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action { warden.authenticate! :api, scope: :user }

  def welcome
    render json: { message: 'events/v1' }
  end
end
