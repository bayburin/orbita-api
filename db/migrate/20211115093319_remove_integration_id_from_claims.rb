class RemoveIntegrationIdFromClaims < ActiveRecord::Migration[6.0]
  def up
    remove_index :claims, name: 'claim_by_integration_application_ticket_identity'
    remove_column :claims, :integration_id
  end

  def down
    add_column :claims, :integration_id, :integer, after: :id, limit: 8
    add_index :claims, [:integration_id, :application_id, :ticket_identity], unique: true, name: 'claim_by_integration_application_ticket_identity'
  end
end
