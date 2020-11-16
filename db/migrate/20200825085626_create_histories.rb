class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.references :work, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.text :action
      t.references :event_type, foreign_key: true, null: false
      t.timestamps
    end
  end
end
