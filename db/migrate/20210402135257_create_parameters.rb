class CreateParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :parameters do |t|
      t.references :claim, foreign_key: true, null: false
      t.string :name, null: false
      t.text :value
      t.timestamps
    end
  end
end
