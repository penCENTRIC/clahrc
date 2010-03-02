class CreateMessageRecipients < ActiveRecord::Migration
  def self.up
    create_table :message_recipients do |t|
      t.references :message
      t.references :recipient
      t.timestamps
    end
    
    add_index :message_recipients, [ :message_id, :recipient_id ], :unique => true
  end

  def self.down
    drop_table :message_recipients
  end
end