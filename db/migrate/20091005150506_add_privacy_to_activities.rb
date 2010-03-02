class AddPrivacyToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :private, :boolean, :default => false
    add_column :activities, :hidden, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :private
    remove_column :activities, :hidden
  end
end
