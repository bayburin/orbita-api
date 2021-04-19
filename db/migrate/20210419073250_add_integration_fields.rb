class AddIntegrationFields < ActiveRecord::Migration[6.0]
  def change
    add_column :claims, :integration_id, :integer, after: :id
    add_reference :claims, :application, foreign_key: { to_table: :oauth_applications }, after: :integration_id
    add_index :claims, [:integration_id, :application_id], unique: true
  end
end
