class CreateActionTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :action_templates do |t|
      t.string :name, limit: 45, index: true
      t.string :template, limit: 255
    end
  end
end
