class ClaimsController < ApplicationController
  def index
    render json: Claim.all
  end
end
