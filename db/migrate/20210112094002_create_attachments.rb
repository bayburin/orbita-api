class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.references :claim, foreign_key: true, null: false
      t.string :attachment
      t.timestamps
    end
  end
end
