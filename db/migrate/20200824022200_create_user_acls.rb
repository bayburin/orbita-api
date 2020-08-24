class CreateUserAcls < ActiveRecord::Migration[6.0]
  def change
    create_table :user_acls do |t|
      t.references :user, foreign_key: true, null: false
      t.references :acl, foreign_key: true, null: false
      t.boolean :value, default: false
    end
  end
end
