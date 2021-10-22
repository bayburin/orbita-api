class AddIsPublicToAttachments < ActiveRecord::Migration[6.0]
  def change
    add_column :attachments, :is_public, :boolean, default: false, after: :attachment, null: false
  end
end
