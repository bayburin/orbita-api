class Api::V1::AttachmentsController < Api::V1::BaseController
  def show
    attachment = Claim.find(params[:claim_id]).attachments.find(params[:id])

    send_file attachment.attachment.file.file
  rescue ActionController::MissingFile
    render status: :not_found
  end
end
