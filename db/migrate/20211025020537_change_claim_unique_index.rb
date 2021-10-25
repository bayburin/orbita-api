class ChangeClaimUniqueIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :claims, column: [:integration_id, :application_id]
    add_index :claims, [:integration_id, :application_id, :ticket_identity], unique: true, name: 'claim_by_integration_application_ticket_identity'
  end
end
