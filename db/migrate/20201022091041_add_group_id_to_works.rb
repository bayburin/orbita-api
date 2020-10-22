class AddGroupIdToWorks < ActiveRecord::Migration[6.0]
  def change
    add_reference :works, :group, foreign_key: true, after: :claim_id, index: true, null: false
  end
end
