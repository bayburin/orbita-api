class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :claim, foreign_key: true
      t.references :work, foreign_key: true
      t.references :sender, foreign_key: { to_table: :users }, null: false
      t.string :type
      t.text :message
      t.timestamps
    end
  end
end
