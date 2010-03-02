class CreateReceivedMessages < ActiveRecord::Migration
  def self.up
    create_table :received_messages do |t|
      t.references :user
      t.references :message
      t.boolean    :read, :default => false
      t.timestamps
    end
    
    add_index :received_messages, [ :user_id, :message_id ]
  end

  def self.down
    drop_table :received_messages
  end
end