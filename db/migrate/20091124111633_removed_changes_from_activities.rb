class RemovedChangesFromActivities < ActiveRecord::Migration
  def self.up
     remove_column :activities, :changed
     remove_column :activities, :changes
   end

   def self.down
     add_column :activities, :changed, :boolean, :default => false
     add_column :activities, :changes, :text
   end
end
