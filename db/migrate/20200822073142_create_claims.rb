class CreateClaims < ActiveRecord::Migration[6.0]
  def change
    create_table :claims do |t|
      t.integer :service_id
      t.integer :app_template_id
      t.string :service_name
      t.string :app_template_name
      t.string :type
      t.text :description
      t.integer :status, limit: 1, index: true
      t.integer :priority, limit: 1, index: true
      t.json :attrs
      t.integer :rating, limit: 1
      t.datetime :finished_at_plan
      t.datetime :finished_at
      t.timestamps
    end
  end
end
