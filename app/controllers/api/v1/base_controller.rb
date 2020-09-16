class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  def welcome
    render json: { message: 'v1' }
  end
end
