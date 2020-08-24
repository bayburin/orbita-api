class AddGroupIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :group, foreign_key: true, after: :role_id, null: false
  end
end
