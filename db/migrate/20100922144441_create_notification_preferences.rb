class CreateNotificationPreferences < ActiveRecord::Migration
  def self.up
    create_table :notification_preferences do |t|
      t.integer :user_id, :context_id
      t.string :context_type, :event, :notification_type, :notification_period
      t.timestamps
    end
    add_index :notification_preferences, :user_id
    add_index :notification_preferences, [:user_id, :context_id, :context_type], :name => 'with_context'
  end

  def self.down
    remove_index :notification_preferences, :name => 'with_context'
    remove_index :notification_preferences, :user_id
    drop_table :notification_preferences
  end
end