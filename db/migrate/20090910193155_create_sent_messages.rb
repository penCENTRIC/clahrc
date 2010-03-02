class CreateSentMessages < ActiveRecord::Migration
  def self.up
    create_table :sent_messages do |t|
      t.references :user
      t.references :message
      t.timestamps
    end
    
    add_index :sent_messages, [ :user_id, :message_id ]
  end

  def self.down
    drop_table :sent_messages
  end
end