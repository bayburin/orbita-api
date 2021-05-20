class Api::V1::BaseController < ApplicationController
  before_action :authenticate_user!

  def welcome
    render json: { message: 'v1' }
  end

  protected

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
