class ClaimApplication < ApplicationRecord
  belongs_to :claim
  belongs_to :application, class_name: 'Doorkeeper::Application'

  validate :unique_application_claim, on: :create

  def unique_application_claim
    return unless claim
    return if ClaimsQuery.new.search_into_ticket_identity(claim.ticket_identity, application_id, integration_id).none?

    errors.add(:integration_id, :taken)
  end
end
