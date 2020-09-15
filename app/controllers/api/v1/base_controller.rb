class Api::V1::BaseController < ApplicationController
  def welcome
    render json: { message: 'v1' }
  end
end
