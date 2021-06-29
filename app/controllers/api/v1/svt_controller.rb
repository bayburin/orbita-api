class Api::V1::SvtController < Api::V1::BaseController
  def find_by_barcode
    svt_response = Svt::Api.find_by_barcode(params[:barcode])

    render json: svt_response.body, status: svt_response.status
  end
end
