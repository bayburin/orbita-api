class CreateWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :works do |t|
      t.references :claim, foreign_key: true, null: false
      t.timestamps
    end
  end
end
