class CreateClaimApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :claim_applications do |t|
      t.references :claim, foreign_key: true, null: false
      t.references :application, foreign_key: { to_table: :oauth_applications }, null: false
      t.integer :integration_id, limit: 8
      t.timestamps
    end
  end
end
