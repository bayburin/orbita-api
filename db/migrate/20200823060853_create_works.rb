class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.references :claim, foreign_key: true, null: false
      t.string :title, limit: 45
      t.integer :status, limit: 1, index: true
      t.json :attrs
      t.timestamps
    end
  end
end
