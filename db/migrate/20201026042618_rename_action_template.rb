class RenameActionTemplate < ActiveRecord::Migration[6.0]
  def change
    rename_table :action_templates, :event_types
    add_column :event_types, :description, :string, after: :name
    change_column :event_types, :name, :integer, limit: 1, index: true
    remove_column :histories, :action_type, :integer, limit: 1
    add_reference :histories, :event_type, foreign_key: true, after: :id
  end
end
