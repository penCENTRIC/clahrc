class AddLockingToContents < ActiveRecord::Migration
  def self.up
    change_table :contents do |t|
      t.boolean    :locked, :boolean, :default => false
      t.datetime   :locked_at
      t.references :locked_by
    end
  end

  def self.down
    remove_column :contents, :locked
    remove_column :contents, :locked_at
    remove_column :contents, :locked_by
  end
end
