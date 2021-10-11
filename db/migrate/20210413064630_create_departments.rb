class CreateDepartments < ActiveRecord::Migration[6.0]
  def change
    create_table :departments do |t|
      t.integer :dept
      t.timestamps
    end

    add_reference :groups, :department, foreign_key: true, after: :id, index: true
  end
end
