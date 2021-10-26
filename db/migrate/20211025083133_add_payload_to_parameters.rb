class AddPayloadToParameters < ActiveRecord::Migration[6.0]
  def change
    add_column :parameters, :schema_version, :integer, null: false, default: 1, after: :claim_id
    add_column :parameters, :payload, :json, after: :schema_version
    remove_column :parameters, :name
    remove_column :parameters, :value
  end
end
