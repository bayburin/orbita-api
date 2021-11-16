class RemoveApplicationIdFromClaims < ActiveRecord::Migration[6.0]
  def up
    remove_reference :claims, :application, foreign_key: { to_table: :oauth_applications }
  end

  def down
    add_reference :claims, :application, foreign_key: { to_table: :oauth_applications }, after: :id
  end
end
