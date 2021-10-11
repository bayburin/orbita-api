class AddRoleIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :role, foreign_key: true, after: :id, null: false
  end
end
