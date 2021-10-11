class AddBarcodeToSourceSnapshot < ActiveRecord::Migration[6.0]
  def change
    add_column :source_snapshots, :barcode, :integer, limit: 8, after: :svt_item_id
  end
end
