class AddUserMessageType < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :accept_value, :boolean, after: :message
    add_column :messages, :accept_comment, :text, after: :accept_value
    add_column :messages, :accept_endpoint, :text, after: :accept_comment
  end
end
