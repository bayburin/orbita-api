class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name, limit: 45, index: true
      t.string :description, limit: 255
      t.timestamps
    end
  end
end
