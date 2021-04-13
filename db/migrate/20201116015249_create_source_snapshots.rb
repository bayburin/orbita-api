class CreateSourceSnapshots < ActiveRecord::Migration[6.0]
  def change
    create_table :source_snapshots do |t|
      t.references :claim, foreign_key: true, null: false
      t.integer :id_tn, index: true
      t.integer :tn, index: true
      t.string :fio, limit: 255, index: true
      t.integer :dept, index: true
      t.json :user_attrs
      t.string :domain_user, limit: 45
      t.string :dns, limit: 255
      t.string :source_ip, limit: 15
      t.string :destination_ip, limit: 15
      t.string :mac, limit: 48
      t.string :invent_num, limit: 64
      t.integer :svt_item_id
      t.string :host_location
      t.string :os, limit: 64
      t.string :netbios, limit: 15
      t.timestamps
    end
  end
end
