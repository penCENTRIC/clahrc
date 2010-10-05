class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :activity_id
      t.integer :user_id
      t.boolean :for_digest
      t.boolean :sent

      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end
