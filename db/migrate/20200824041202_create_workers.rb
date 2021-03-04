class CreateWorkers < ActiveRecord::Migration[6.0]
  def change
    create_table :workers, id: false do |t|
      t.references :work, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end

    add_index :workers, [:work_id, :user_id], unique: true
  end
end
