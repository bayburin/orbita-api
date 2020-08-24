class CreateGroupAcls < ActiveRecord::Migration[6.0]
  def change
    create_table :group_acls do |t|
      t.references :role, foreign_key: true, null: false
      t.references :group, foreign_key: true, null: false
      t.references :acl, foreign_key: true, null: false
      t.boolean :value, default: false
      t.timestamps
    end
  end
end
