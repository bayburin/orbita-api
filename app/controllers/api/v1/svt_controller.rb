class Api::V1::SvtController < Api::V1::BaseController
  def items
    svt_response = Svt::Api.query_items(JSON.parse(params[:filters]))

    render json: svt_response.body, status: svt_response.status, adapter: :attributes
  end

  def find_by_barcode
    svt_response = Svt::Api.find_by_barcode(params[:barcode])

    render json: svt_response.body, status: svt_response.status, adapter: :attributes
  end
end
