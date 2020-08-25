class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.references :work, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :action
      t.integer :action_type, limit: 1, index: true
      t.timestamps
    end
  end
end
