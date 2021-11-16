class ClaimApplication < ApplicationRecord
  belongs_to :claim
  belongs_to :application, class_name: 'Doorkeeper::Application'

  validate :unique_application_claim, on: :create

  def unique_application_claim
    return unless claim
    return if Claim.joins(:claim_applications).where(
      ticket_identity: claim.ticket_identity,
      claim_applications: { integration_id: integration_id, application_id: application_id }
    ).none?

    errors.add(:integration_id, :taken)
  end
end
