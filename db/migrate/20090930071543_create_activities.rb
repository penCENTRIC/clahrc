class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string     :type
      t.references :trackable, :polymorphic => true
      t.references :user
      t.references :group
      t.string     :controller
      t.string     :action
      t.boolean    :changed
      t.text       :changes
      t.boolean    :notified, :default => false
      t.timestamps
    end
    
    change_table :activities do |t|
      t.index      :type
      t.index    [ :trackable_type, :trackable_id ]
      t.index      :user_id
      t.index      :group_id
    end
  end

  def self.down
    drop_table :activities
  end
end
