class CreateEventTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :event_types do |t|
      t.integer :name, limit: 1, index: true
      t.string :description
      t.string :template, limit: 255
      t.boolean :is_public, default: false, index: true
      t.integer :order
    end
  end
end
